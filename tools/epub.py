"""EPUB → ordered (title, text) sections, stdlib only (zipfile + ElementTree)."""

from __future__ import annotations

import html
import posixpath
import re
import zipfile
from xml.etree import ElementTree as ET

OPF_NS = "http://www.idpf.org/2007/opf"
NCX_NS = "http://www.daisy.org/z3986/2005/ncx/"

_TAG_RE = re.compile(r"<[^>]+>")
_BLOCK_RE = re.compile(r"</?(?:p|div|h[1-6]|li|tr|br|section|article|table)\b[^>]*>", re.I)


def _decode(data: bytes) -> str:
    for enc in ("utf-8", "cp1251"):
        try:
            return data.decode(enc)
        except UnicodeDecodeError:
            continue
    return data.decode("utf-8", "replace")


def _strip_xhtml(data: bytes) -> str:
    text = _decode(data)
    text = re.sub(r"(?is)<(script|style)\b[^>]*>.*?</\1>", " ", text)
    text = _BLOCK_RE.sub("\n", text)
    text = _TAG_RE.sub(" ", text)
    text = html.unescape(text)
    text = re.sub(r"[ \t]+", " ", text)
    text = re.sub(r"\n\s*\n+", "\n\n", text)
    return text.strip()


def _first_heading(text: str) -> str:
    for line in text.splitlines():
        line = line.strip()
        if line:
            return line
    return ""


def _nav_titles(z: zipfile.ZipFile, ncx_path: str | None, base: str) -> dict[str, str]:
    if not ncx_path:
        return {}
    try:
        root = ET.fromstring(_decode(z.read(ncx_path)))
    except (KeyError, ET.ParseError):
        return {}
    out = {}
    for np_ in root.iter(f"{{{NCX_NS}}}navPoint"):
        text_el = np_.find(f"{{{NCX_NS}}}navLabel/{{{NCX_NS}}}text")
        content_el = np_.find(f"{{{NCX_NS}}}content")
        if text_el is None or content_el is None:
            continue
        href = content_el.get("src", "").split("#", 1)[0]
        key = posixpath.normpath(posixpath.join(base, href)).replace("\\", "/")
        out[key] = (text_el.text or "").strip()
    return out


def sections(epub_path: str) -> list[tuple[str, str]]:
    """Return spine-ordered (title, text) for every non-empty content document."""
    with zipfile.ZipFile(epub_path) as z:
        container = _decode(z.read("META-INF/container.xml"))
        m = re.search(r'full-path="([^"]+)"', container)
        if not m:
            raise ValueError("no OPF path in container.xml")
        opf_path = m.group(1)
        opf = ET.fromstring(_decode(z.read(opf_path)))
        base = posixpath.dirname(opf_path)

        manifest: dict[str, str] = {}
        ncx_path: str | None = None
        for item in opf.iter(f"{{{OPF_NS}}}item"):
            iid = item.get("id")
            href = item.get("href")
            if not iid or not href:
                continue
            key = posixpath.normpath(posixpath.join(base, href)).replace("\\", "/")
            manifest[iid] = key
            if item.get("media-type") == "application/x-dtbncx+xml":
                ncx_path = key

        titles = _nav_titles(z, ncx_path, base)
        out: list[tuple[str, str]] = []
        for ref in opf.iter(f"{{{OPF_NS}}}itemref"):
            href = manifest.get(ref.get("idref"))
            if not href:
                continue
            try:
                data = z.read(href)
            except KeyError:
                continue
            text = _strip_xhtml(data)
            if not text:
                continue
            title = titles.get(href) or _first_heading(text) or posixpath.basename(href)
            out.append((title, text))
        return out


def split_chunks(text: str, size: int = 2000) -> list[str]:
    """Split text into ~`size`-char chunks on paragraph boundaries."""
    paras = [p.strip() for p in text.split("\n\n") if p.strip()]
    chunks: list[str] = []
    cur = ""
    for p in paras:
        if cur and len(cur) + len(p) + 2 > size:
            chunks.append(cur.strip())
            cur = p
        else:
            cur = f"{cur}\n\n{p}" if cur else p
    if cur.strip():
        chunks.append(cur.strip())
    return chunks

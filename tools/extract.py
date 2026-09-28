"""PDF/EPUB → extract/<slug>/page-NNNN.txt"""

from __future__ import annotations

import argparse
import re
from pathlib import Path

from pypdf import PdfReader

from common import EXTRACT_DIR, ROOT, book_by_slug, load_books, utf8_stdout
from epub import sections as epub_sections, split_chunks


def page_text(page) -> str:
    raw = page.extract_text() or ""
    text = raw.replace("\x00", " ")
    text = re.sub(r"[ \t]+", " ", text)
    text = re.sub(r"\n{3,}", "\n\n", text)
    return text.strip()


def extract_pdf_book(slug: str, pdf_path: Path) -> int:
    out_dir = EXTRACT_DIR / slug
    out_dir.mkdir(parents=True, exist_ok=True)
    reader = PdfReader(str(pdf_path))
    written = 0
    for i, page in enumerate(reader.pages, start=1):
        body = page_text(page)
        dest = out_dir / f"page-{i:04d}.txt"
        dest.write_text(f"----- PAGE {i} -----\n{body}\n", encoding="utf-8")
        written += 1
    print(f"{slug}: {written} pages → {out_dir}")
    return written


def extract_epub_book(slug: str, epub_path: Path) -> int:
    out_dir = EXTRACT_DIR / slug
    out_dir.mkdir(parents=True, exist_ok=True)
    page = 1
    ranges: list[tuple[str, int, int]] = []
    for title, text in epub_sections(str(epub_path)):
        start = page
        for chunk in split_chunks(text):
            dest = out_dir / f"page-{page:04d}.txt"
            dest.write_text(f"----- PAGE {page} -----\n{chunk}\n", encoding="utf-8")
            page += 1
        ranges.append((title, start, page - 1))
    print(f"{slug}: {page - 1} pages → {out_dir}")
    print("  section → pages:")
    for title, start, end in ranges:
        print(f"    {start:4d}-{end:4d}  {title}")
    return page - 1


def extract_book(slug: str) -> int:
    book = book_by_slug(slug)
    src = book.get("pdf") or book.get("epub")
    if not src:
        raise FileNotFoundError(f"{slug}: no pdf/epub source")
    src_path = ROOT / src
    if not src_path.is_file():
        raise FileNotFoundError(src_path)
    if src_path.suffix.lower() == ".epub":
        return extract_epub_book(slug, src_path)
    return extract_pdf_book(slug, src_path)


def main() -> None:
    utf8_stdout()
    parser = argparse.ArgumentParser(description="Extract PDF/EPUB pages to extract/<slug>/")
    parser.add_argument("--slug", help="one book slug from corpus/books.json")
    parser.add_argument("--all", action="store_true", help="all books that have a pdf/epub")
    args = parser.parse_args()
    slugs: list[str]
    if args.all:
        slugs = [b["slug"] for b in load_books()["books"] if b.get("pdf") or b.get("epub")]
    elif args.slug:
        slugs = [args.slug]
    else:
        parser.error("pass --slug or --all")
        return
    for slug in slugs:
        extract_book(slug)


if __name__ == "__main__":
    main()

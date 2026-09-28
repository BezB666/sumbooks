"""Chunk extract/ + notes + concepts into index/books.sqlite."""

from __future__ import annotations

import argparse
import re
from pathlib import Path

import numpy as np

from common import (
    CONCEPTS_DIR,
    EXTRACT_DIR,
    ROOT,
    book_by_slug,
    chapter_for_page,
    embed_texts,
    load_books,
    load_indexed,
    mark_indexed,
    open_db,
    replace_rows,
    utf8_stdout,
    vec_to_blob,
)

MIN_CHARS = 80
NOTE_SPLIT = re.compile(r"(?=^#{1,3} )", re.M)


def page_body(path: Path) -> tuple[int, str]:
    text = path.read_text(encoding="utf-8")
    m = re.match(r"----- PAGE (\d+) -----\s*", text)
    if m:
        return int(m.group(1)), text[m.end() :].strip()
    return 0, text.strip()


def ingest_pages(conn, slug: str) -> int:
    book = book_by_slug(slug)
    folder = EXTRACT_DIR / slug
    if not folder.is_dir():
        print(f"skip pages {slug}: no {folder}")
        return 0
    files = sorted(folder.glob("page-*.txt"))
    rows = []
    for path in files:
        page, body = page_body(path)
        if len(body) < MIN_CHARS:
            continue
        ch = chapter_for_page(book, page) if page else None
        title = ch["title"] if ch else book["title"]
        chapter_id = ch["id"] if ch else None
        rows.append(
            {
                "type": "chunk",
                "book": slug,
                "chapter": chapter_id,
                "page": page,
                "path": str(path.relative_to(ROOT)).replace("\\", "/"),
                "title": f"{book['title']} p.{page} — {title}",
                "text": body,
            }
        )
    return _insert(conn, slug, "chunk", rows)


def split_markdown(path: Path) -> list[tuple[str, str]]:
    text = path.read_text(encoding="utf-8")
    parts = [p.strip() for p in NOTE_SPLIT.split(text) if p.strip()]
    out = []
    for part in parts:
        first = part.splitlines()[0]
        title = first.lstrip("#").strip() or path.stem
        out.append((title, part))
    return out or [(path.stem, text)]


def ingest_notes(conn, slug: str) -> int:
    book = book_by_slug(slug)
    notes = book.get("notes")
    if not notes:
        return 0
    root = ROOT / notes
    files: list[Path] = []
    if root.is_file():
        files = [root]
    elif root.is_dir():
        files = sorted(root.rglob("*.md"))
    rows = []
    for path in files:
        rel = str(path.relative_to(ROOT)).replace("\\", "/")
        for title, body in split_markdown(path):
            if len(body) < MIN_CHARS:
                continue
            rows.append(
                {
                    "type": "note",
                    "book": slug,
                    "chapter": path.stem,
                    "page": None,
                    "path": rel,
                    "title": f"{book['title']} / {title}",
                    "text": body,
                }
            )
    return _insert(conn, slug, "note", rows)


def ingest_concepts(conn) -> int:
    if not CONCEPTS_DIR.is_dir():
        return 0
    rows = []
    for path in sorted(CONCEPTS_DIR.glob("*.md")):
        body = path.read_text(encoding="utf-8").strip()
        if len(body) < MIN_CHARS:
            continue
        title = path.stem
        first = body.splitlines()[0]
        if first.startswith("#"):
            title = first.lstrip("#").strip()
        rows.append(
            {
                "type": "concept",
                "book": "corpus",
                "chapter": path.stem,
                "page": None,
                "path": str(path.relative_to(ROOT)).replace("\\", "/"),
                "title": title,
                "text": body,
            }
        )
    return _insert(conn, "corpus", "concept", rows)


def _insert(conn, book: str, type_: str, rows: list[dict]) -> int:
    replace_rows(conn, book=book, type_=type_)
    if not rows:
        conn.commit()
        return 0
    print(f"embed {len(rows)} {type_} rows for {book}…", flush=True)
    texts = [r["text"] for r in rows]
    vec_parts = []
    batch = 64
    for i in range(0, len(texts), batch):
        vec_parts.append(embed_texts(texts[i : i + batch]))
        print(f"  {min(i + batch, len(texts))}/{len(texts)}", flush=True)
    vecs = np.vstack(vec_parts)
    for row, vec in zip(rows, vecs):
        conn.execute(
            """
            INSERT INTO chunks (type, book, chapter, page, path, title, text, embedding)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """,
            (
                row["type"],
                row["book"],
                row["chapter"],
                row["page"],
                row["path"],
                row["title"],
                row["text"],
                vec_to_blob(vec),
            ),
        )
    conn.commit()
    print(f"  stored {len(rows)}", flush=True)
    return len(rows)


def main() -> None:
    utf8_stdout()
    parser = argparse.ArgumentParser(description="Embed extract/ notes / concepts into sqlite")
    parser.add_argument("--slug")
    parser.add_argument("--all", action="store_true")
    parser.add_argument("--pages", action="store_true")
    parser.add_argument("--notes", action="store_true")
    parser.add_argument("--concepts", action="store_true")
    parser.add_argument("--force", action="store_true", help="re-ingest slugs already marked in books/INDEXED.txt")
    args = parser.parse_args()
    do_pages = args.pages or args.all or (not args.notes and not args.concepts)
    do_notes = args.notes or args.all
    do_concepts = args.concepts or args.all
    full = do_pages and do_notes
    if args.slug:
        slugs = [args.slug]
    else:
        slugs = [b["slug"] for b in load_books()["books"]]
    done = load_indexed()
    conn = open_db()
    try:
        if do_pages or do_notes:
            for slug in slugs:
                if slug in done and not args.force:
                    print(f"skip {slug}: already indexed (use --force to redo)")
                    continue
                book = book_by_slug(slug)
                if do_pages and (book.get("pdf") or book.get("epub")):
                    ingest_pages(conn, slug)
                if do_notes:
                    ingest_notes(conn, slug)
                if full:
                    mark_indexed(slug)
        if do_concepts:
            ingest_concepts(conn)
    finally:
        conn.close()


if __name__ == "__main__":
    main()

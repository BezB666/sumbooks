"""Update chapter ids on existing chunk rows after books.json TOC changes."""

from __future__ import annotations

import argparse

from common import book_by_slug, chapter_for_page, open_db, utf8_stdout


def retag(slug: str) -> int:
    book = book_by_slug(slug)
    conn = open_db()
    n = 0
    try:
        rows = conn.execute(
            "SELECT id, page, title FROM chunks WHERE book = ? AND type = 'chunk'",
            (slug,),
        ).fetchall()
        for row in rows:
            page = row["page"]
            if not page:
                continue
            ch = chapter_for_page(book, page)
            if not ch:
                continue
            title = f"{book['title']} p.{page} — {ch['title']}"
            conn.execute(
                "UPDATE chunks SET chapter = ?, title = ? WHERE id = ?",
                (ch["id"], title, row["id"]),
            )
            n += 1
        conn.commit()
    finally:
        conn.close()
    print(f"{slug}: retagged {n} chunks")
    return n


def main() -> None:
    utf8_stdout()
    parser = argparse.ArgumentParser()
    parser.add_argument("--slug", required=True)
    args = parser.parse_args()
    retag(args.slug)


if __name__ == "__main__":
    main()

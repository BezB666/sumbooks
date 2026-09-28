"""Semantic search over index/books.sqlite."""

from __future__ import annotations

import argparse
import json
import sys

import numpy as np

from common import blob_to_vec, embed_texts, open_db, utf8_stdout


def search(query: str, k: int, book: str | None, type_: str | None) -> list[dict]:
    q = embed_texts([query])[0]
    qn = np.linalg.norm(q) or 1.0
    sql = "SELECT id, type, book, chapter, page, path, title, text, embedding FROM chunks"
    params: list = []
    where = []
    if book:
        where.append("book = ?")
        params.append(book)
    if type_:
        where.append("type = ?")
        params.append(type_)
    if where:
        sql += " WHERE " + " AND ".join(where)
    conn = open_db()
    try:
        rows = conn.execute(sql, params).fetchall()
    finally:
        conn.close()
    scored = []
    for row in rows:
        v = blob_to_vec(row["embedding"])
        vn = np.linalg.norm(v) or 1.0
        score = float(np.dot(q, v) / (qn * vn))
        scored.append((score, row))
    scored.sort(key=lambda x: x[0], reverse=True)
    hits = []
    for score, row in scored[:k]:
        text = row["text"]
        snippet = text if len(text) <= 900 else text[:900] + "…"
        hits.append(
            {
                "score": round(score, 4),
                "type": row["type"],
                "book": row["book"],
                "chapter": row["chapter"],
                "page": row["page"],
                "path": row["path"],
                "title": row["title"],
                "snippet": snippet,
            }
        )
    return hits


def main() -> None:
    utf8_stdout()
    parser = argparse.ArgumentParser(description="Search the book vector index")
    parser.add_argument("query")
    parser.add_argument("-k", type=int, default=8)
    parser.add_argument("--book", help="filter by slug (eip, building-microservices, …)")
    parser.add_argument("--type", choices=["chunk", "note", "concept"])
    parser.add_argument("--json", action="store_true")
    args = parser.parse_args()
    hits = search(args.query, args.k, args.book, args.type)
    if args.json:
        json.dump(hits, sys.stdout, ensure_ascii=False, indent=2)
        print()
        return
    if not hits:
        print("no hits")
        return
    for i, hit in enumerate(hits, 1):
        loc = hit["book"]
        if hit["chapter"]:
            loc += f" / {hit['chapter']}"
        if hit["page"]:
            loc += f" p.{hit['page']}"
        print(f"{i}. {hit['score']:.3f}  [{hit['type']}]  {loc}")
        print(f"   {hit['title']}")
        print(f"   {hit['path']}")
        print()
        print(hit["snippet"])
        print()
        print("---")
        print()


if __name__ == "__main__":
    main()

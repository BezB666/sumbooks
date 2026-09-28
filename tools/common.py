"""Shared paths, book registry, embeddings, sqlite helpers."""

from __future__ import annotations

import json
import sqlite3
import sys
from functools import lru_cache
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parent.parent
EXTRACT_DIR = ROOT / "extract"
INDEX_DIR = ROOT / "index"
DB_PATH = INDEX_DIR / "books.sqlite"
BOOKS_JSON = ROOT / "corpus" / "books.json"
CONCEPTS_DIR = ROOT / "corpus" / "concepts"
INDEXED_FILE = ROOT / "books" / "INDEXED.txt"

# RU question ↔ EN book. No query/passage prefixes.
MODEL_NAME = "sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2"

SCHEMA = """
CREATE TABLE IF NOT EXISTS chunks (
    id INTEGER PRIMARY KEY,
    type TEXT NOT NULL,
    book TEXT NOT NULL,
    chapter TEXT,
    page INTEGER,
    path TEXT,
    title TEXT,
    text TEXT NOT NULL,
    embedding BLOB NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_chunks_book ON chunks(book);
CREATE INDEX IF NOT EXISTS idx_chunks_type ON chunks(type);
"""

_model = None


def utf8_stdout() -> None:
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")


@lru_cache(maxsize=1)
def load_books() -> dict:
    return json.loads(BOOKS_JSON.read_text(encoding="utf-8"))


def book_by_slug(slug: str) -> dict:
    for book in load_books()["books"]:
        if book["slug"] == slug:
            return book
    raise KeyError(f"unknown book slug: {slug}")


def chapter_for_page(book: dict, page: int) -> dict | None:
    for ch in book.get("chapters") or []:
        if ch["start"] <= page <= ch["end"]:
            return ch
    return None


def load_indexed() -> set[str]:
    if not INDEXED_FILE.is_file():
        return set()
    return {line.strip() for line in INDEXED_FILE.read_text(encoding="utf-8").splitlines() if line.strip()}


def mark_indexed(slug: str) -> None:
    slugs = load_indexed()
    if slug in slugs:
        return
    INDEXED_FILE.parent.mkdir(parents=True, exist_ok=True)
    with INDEXED_FILE.open("a", encoding="utf-8") as f:
        f.write(slug + "\n")


def embedder():
    global _model
    if _model is None:
        import warnings

        from fastembed import TextEmbedding

        warnings.filterwarnings("ignore", message="The model sentence-transformers")
        _model = TextEmbedding(model_name=MODEL_NAME)
    return _model


def embed_texts(texts: list[str]) -> np.ndarray:
    vecs = list(embedder().embed(texts))
    return np.vstack(vecs).astype(np.float32)


def vec_to_blob(vec: np.ndarray) -> bytes:
    return np.asarray(vec, dtype=np.float32).tobytes()


def blob_to_vec(blob: bytes) -> np.ndarray:
    return np.frombuffer(blob, dtype=np.float32)


def open_db() -> sqlite3.Connection:
    INDEX_DIR.mkdir(parents=True, exist_ok=True)
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    conn.executescript(SCHEMA)
    return conn


def replace_rows(conn: sqlite3.Connection, *, book: str, type_: str) -> None:
    conn.execute("DELETE FROM chunks WHERE book = ? AND type = ?", (book, type_))

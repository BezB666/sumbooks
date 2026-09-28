# sumbooks

Личная библиотека конспектов книг по разработке ПО: пошаговые заметки по
главам, карточки концептов и семантический поиск по всему этому с помощью
эмбеддингов (SQLite + fastembed).

## Структура

| Путь | Что это |
|---|---|
| `*/chapters/*.md` | Конспекты по главам (одна папка на книгу: `ddia`, `eip`, `gof`, …) |
| `*/INDEX.md` | Оглавление-индекс книги |
| `corpus/` | Карточки концептов и перекрёстные ссылки (`concepts/`, `aliases.md`, `books.json`) |
| `tools/` | Python-скрипты конвейера: извлечение → индексация → поиск |
| `index/` | `books.sqlite` с эмбеддингами (генерируется, в git не хранится) |
| `extract/` | Сырой извлечённый текст книг (генерируется, в git не хранится) |
| `books/` | Исходные PDF/EPUB (личные файлы, в git не хранятся) |

## Установка

```bash
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
```

## Конвейер

```bash
# 1. Извлечь текст книги в extract/<slug>/page-NNNN.txt
python -m tools.extract --slug eip

# 2. Разбить на куски, посчитать эмбеддинги и сложить в index/books.sqlite
python -m tools.ingest --slug eip          # одна книга
python -m tools.ingest --all               # все книги
python -m tools.ingest --concepts          # карточки из corpus/concepts/

# 3. Семантический поиск
python -m tools.search "message router" --book eip -k 5
python -m tools.search "saga" --json
```

Также есть `python -m tools.retag_chapters` для переназначения глав-страниц
после пересборки индекса.

## Как устроено

1. **extract** — pypdf/epub-парсер превращает книгу в текстовые страницы
   `extract/<slug>/page-0001.txt`.
2. **ingest** — режет страницы и заметки на куски, считает эмбеддинги
   (fastembed), складывает в SQLite вместе с источником (книга/глава/страница).
3. **search** — эмбеддинг запроса сравнивается по косинусному сходству со
   всеми кусками, выводятся самые близкие с фрагментом текста.

## Правовой статус

В репозитории — только собственные конспекты и код. Сами книги (PDF/EPUB),
их полный извлечённый текст (`extract/`) и собранный индекс (`index/`) не
публикуются.

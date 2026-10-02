# Corpus — индекс по книгам

Открытый вопрос: `py tools/search.py "запрос"` → сюда → саммари главы → PDF.

Оригиналы в `books/`. Полный текст и sqlite (`extract/`, `index/`) локальные, не в git.

## Книги

| Slug | Книга | Заметки | Вектор |
|---|---|---|---|
| eip | Hohpe, Woolf — Enterprise Integration Patterns | [eip/INDEX.md](../eip/INDEX.md) | PDF + notes |
| gof | Gamma et al. — Design Patterns | [gof/gof-patterns.md](../gof/gof-patterns.md) | notes only (PDF нет) |
| building-microservices | Newman — Building Microservices, 2nd ed. | [building-microservices/INDEX.md](../building-microservices/INDEX.md) | PDF + notes |
| monolith-to-microservices | Newman — Monolith to Microservices | [monolith-to-microservices/INDEX.md](../monolith-to-microservices/INDEX.md) | PDF + notes |
| ddd | Khononov — Learning Domain-Driven Design | [ddd/INDEX.md](../ddd/INDEX.md) | PDF + notes |
| learning-go | Bodner — Learning Go, 2nd ed. | [learning-go/INDEX.md](../learning-go/INDEX.md) | PDF + notes |
| poeaa | Fowler — Patterns of Enterprise Application Architecture | [poeaa/INDEX.md](../poeaa/INDEX.md) | PDF + notes |
| ddia | Kleppmann — Designing Data-Intensive Applications | [ddia/INDEX.md](../ddia/INDEX.md) | PDF + notes |
| ddia2 | Kleppmann — Designing Data-Intensive Applications, 2nd ed. | [ddia2/INDEX.md](../ddia2/INDEX.md) | PDF + notes |
| fsa | Richards, Ford — Fundamentals of Software Architecture | [fsa/INDEX.md](../fsa/INDEX.md) | PDF + notes |
| hard-parts | Ford, Richards, Sadalage, Dehghani — Software Architecture: The Hard Parts | [hard-parts/INDEX.md](../hard-parts/INDEX.md) | PDF + notes |
| mythical-man-month | Brooks — The Mythical Man-Month (Мифический человеко-месяц) | [mythical-man-month/INDEX.md](../mythical-man-month/INDEX.md) | EPUB + notes |

Реестр страниц глав: [books.json](books.json). Алиасы терминов: [aliases.md](aliases.md).

## Концепты

| Тема | Файл |
|---|---|
| Идемпотентность, дубликаты, at-least-once | [concepts/idempotency.md](concepts/idempotency.md) |
| HTTP-кеш, ETag, условные запросы | [concepts/http-caching.md](concepts/http-caching.md) |
| Messaging vs RPC / файлы / общая БД | [concepts/messaging.md](concepts/messaging.md) |
| Request-Reply, корреляция | [concepts/request-reply.md](concepts/request-reply.md) |
| Pub/sub vs точка-точка | [concepts/pub-sub.md](concepts/pub-sub.md) |
| Adapter / мост / шлюз | [concepts/adapter.md](concepts/adapter.md) |
| Observer | [concepts/observer.md](concepts/observer.md) |
| Failover, Competing Consumers | [concepts/failover.md](concepts/failover.md) |
| Process Manager vs Routing Slip | [concepts/process-manager.md](concepts/process-manager.md) |
| Транзакции, 2PC, саги | [concepts/transactions.md](concepts/transactions.md) |
| Event Sourcing, CDC | [concepts/event-sourcing.md](concepts/event-sourcing.md) |
| Repository, Unit of Work | [concepts/repository.md](concepts/repository.md) |
| Architecture quantum, fitness functions | [concepts/architecture-quantum.md](concepts/architecture-quantum.md) |
| Architecture styles (layered … microservices) | [concepts/architecture-styles.md](concepts/architecture-styles.md) |
| Trade-off analysis, granularity | [concepts/trade-offs.md](concepts/trade-offs.md) |
| Distance from the main sequence, coupling metrics | [concepts/distance-from-main-sequence.md](concepts/distance-from-main-sequence.md) |

Новые концепты (`concepts/`) и их индексацию добавляем **только по явному запросу**: поиск и конспектирование сами по себе в индекс ничего не пишут.

## Как добавлять книгу

1. PDF в `books/`, строка в `books.json`.
2. `py tools/extract.py --slug <slug>`
3. Дописать `chapters` в `books.json` (оглавление + страницы).
4. `py tools/ingest.py --slug <slug> --all` — страницы + заметки + концепты; slug в `books/INDEXED.txt` пишется только после успешного завершения.
5. Саммари глав в `<slug>/` и дописка секций в `concepts/`.
6. Правка уже проиндексированной книги: `py tools/ingest.py --slug <slug> --notes --force` (только заметки) или `--all --force` (полностью).

`books/INDEXED.txt` — список проиндексированных книг (slug на строку). `ingest.py` пропускает книги из этого списка; `--force` пересчитывает заново. Убрать строку из файла = заставить следующий `--all` пересчитать книгу.

EPUB поддерживается: в `books.json` вместо `pdf` ставится `"epub": "books/….epub"`, `extract.py` сам определяет формат по расширению.

# Event Sourcing и CDC

## Алиасы

EN: Event Sourcing, event store, change data capture, CDC, projection, derived data, append-only log  
RU: событийный сорс, журнал изменений, проекция, производные данные

## Упоминания

### Khononov — Learning DDD, гл. 7, PDF 125–142

Event Sourcing: каждое изменение — событие; текущее состояние — проекция. **Event-sourced domain model** = Domain Model, rehydrate из domain events. Не «лог рядом со стейтом». Для запросов почти всегда CQRS (гл. 8). См. [07-modeling-the-dimension-of-time.md](../../ddd/chapters/07-modeling-the-dimension-of-time.md).

### Kleppmann — DDIA, гл. 11, PDF 461–510

**CDC:** changelog БД (часто replication log) → поиск/кеш/склад в том же порядке. Приложение пишет мутабельно, CDC снизу. **Event Sourcing:** приложение само пишет события смысла, не низкоуровневые UPDATE. См. [11-stream-processing.md](../../ddia/chapters/11-stream-processing.md).

### Newman — Monolith to Microservices, гл. 3–4

**Change Data Capture** как паттерн миграции: вытянуть события из монолита, не трогая его API. Tracer Write — два source of truth на время переноса.

### Ford/Richards/Dehghani — Hard Parts, гл. 14, PDF 677–709

Analytical ≠ operational. Warehouse (ETL → одна схема) и lake (load then transform) ломают domain partitioning. **Data mesh:** domain ownership, data as a product, self-serve, federated governance; **data product quantum** рядом с сервисом. См. [14-managing-analytical-data.md](../../hard-parts/chapters/14-managing-analytical-data.md). Рядом Khononov гл. 16.

## Сводка

CDC подслушивает БД. Event Sourcing делает события контрактом домена. Путают часто; Kleppmann разделяет явно. Аналитика: warehouse/lake vs mesh. Идемпотентность потребителя: [idempotency.md](idempotency.md).

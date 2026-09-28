# Repository, Unit of Work, мапперы

## Алиасы

EN: Repository, Unit of Work, Identity Map, Data Mapper, Active Record, Table Data Gateway  
RU: репозиторий, единица работы, карта идентичности, маппер, активная запись

## Упоминания

### Fowler — PoEAA

- Гл. 10, PDF 168–207: Table/Row Data Gateway, Active Record (класс ≈ таблица), Data Mapper (модель и схема порознь).
- Гл. 11, PDF 208–239: **Unit of Work** — помнить изменения, один commit; **Identity Map** — одна строка = один объект в памяти; Lazy Load.
- Гл. 13, PDF 330–353: **Repository** — коллекция + критерии, клиент не отличает память от БД; силён, когда in-memory для тестов vs SQL. См. [11-object-relational-behavioral-patterns.md](../../poeaa/chapters/11-object-relational-behavioral-patterns.md), [13-object-relational-metadata-mapping-patterns.md](../../poeaa/chapters/13-object-relational-metadata-mapping-patterns.md).

### Khononov — Learning DDD, гл. 5–6

Простую логику: Transaction Script / Active Record (цитирует Fowler). Сложный core: Domain Model, aggregate как граница транзакции. Repository в тактике DDD — коллекция aggregate’ов, не таблиц.

## Сводка

Active Record = объект сам ходит в БД. Data Mapper + Unit of Work + Identity Map — когда модель живёт отдельно. Repository — фасад «коллекция», часто поверх Mapper. Не путать с EIP Message Store (архив сообщений).

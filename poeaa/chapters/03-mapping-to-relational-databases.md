# Глава 3. Mapping to Relational Databases

- **PDF:** 58–79 (печать 33–54)
- **Якоря:** Gateway, Active Record, Data Mapper, Unit of Work, Identity Map, Lazy Load, Identity Field, Foreign Key Mapping, inheritance mappings, Metadata Mapping

SQL из домена — в Gateway по таблицам: Table (один объект, Record Set) или Row (экземпляр на строку). Простая модель ≈ таблицы → Active Record. Богаче таблиц → Data Mapper (изоляция, сложность). Не мешать несколько primary-механизмов. «Table» = таблица/view/запрос/stored procedure. OODB редки из-за риска; коммерческий O/R часто дешевле самописного.

Поведение труднее структуры: Unit of Work помнит изменения и сам commit; Identity Map не даёт двум объектам стать одной строкой; Lazy Load не вытягивает весь граф. Finder’ы видят БД, не память; лучше один запрос с лишними строками, чем 50 точечных.

Ссылки объектов vs FK: Identity Field, Foreign Key Mapping, Association Table (many-to-many), Dependent Mapping, Embedded Value, Serialized LOB. Наследование: Single / Class / Concrete Table (Fowler часто стартует с Single). Модель без БД не строить полгода — цикл ≤ 6 недель. Повтор маппинга → Metadata Mapping → Query Object / Repository. Коннекцию закрывать с транзакцией; `SELECT *` с позиционными индексами ломается при перестановке колонок.

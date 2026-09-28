# Глава 12. Object-Relational Structural Patterns

- **PDF:** 240–329 (печать 215–304)
- **Якоря:** Identity Field, Foreign Key Mapping, Association Table Mapping, Dependent Mapping, Embedded Value, Serialized LOB, Single/Class/Concrete Table Inheritance, Inheritance Mappers

Связи объектов vs ключи таблиц; иерархии классов vs SQL без наследования. Смешивать схемы в одной иерархии можно, цена — сложность. Fowler часто стартует с Single Table Inheritance.

| Паттерн | Когда |
|---|---|
| Identity Field | есть соответствие объект ↔ строка (Domain Model, Row Data Gateway). Не нужен Transaction Script / Table Module / Table Data Gateway. Мелочь без своей таблицы — Embedded Value; куст без SQL-запросов внутрь — Serialized LOB |
| Foreign Key Mapping | почти любая ассоциация. Many-to-many — нет (1НФ), тогда Association Table. Коллекция без обратной ссылки — подумать Dependent Mapping; Value Object — Embedded Value |
| Association Table Mapping | канон — many-to-many. Для 1–1/1–N обычно лишний join; имеет смысл, если нельзя добавить колонку к существующим таблицам или схема уже с связующей таблицей |
| Dependent Mapping | объект виден только владельцу (коллекция детей без своей идентичности и без чужих ссылок). Упрощает persist коллекции |
| Embedded Value | Value Object (деньги, интервал дат) — полями в таблице владельца. Серые случаи — мелкие reference object, если не жалко денормализации |
| Serialized LOB | отрезать кусок графа (оргструктура, BOM), не запрашивать его SQL снаружи; XML удобен. Минус — SQL не видит внутренности; не превращать всю БД в файловую систему |
| Single Table Inheritance | одна таблица на иерархию: без join, рефакторинг полей без ALTER каждой таблицы. Минусы — пустые колонки, путаница «поле не для этого типа», широкая таблица как bottleneck |
| Class Table Inheritance | таблица на каждый класс: колонки всегда осмысленны, схема ≈ модель. Минусы — join/несколько запросов, ALTER при сдвиге полей, hotspot на таблице суперкласса |
| Concrete Table Inheritance | таблица на каждый конкретный класс: один объект — одна таблица, без join. Хрупко к изменению суперкласса; ключи и FK неудобнее |
| Inheritance Mappers | иерархия мапперов параллельно иерархии домена: одно место менять маппинг класса; абстрактные классы делегируют конкретным. Каркас один для всех трёх схем таблиц |

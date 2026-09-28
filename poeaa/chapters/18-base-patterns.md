# Глава 18. Base Patterns

- **PDF:** 490–535 (печать 465–510)
- **Якоря:** Gateway, Mapper, Layer Supertype, Separated Interface, Registry, Value Object, Money, Special Case, Plugin, Service Stub, Record Set

Не enterprise-специфичные кирпичи, на которые ссылаются остальные главы.

| Паттерн | Когда |
|---|---|
| Gateway | неудобный внешний интерфейс (БД, налог, очередь): не размазывать awkwardness. Точка для Service Stub и смены вендора |
| Mapper | надо развязать две стороны так, чтобы *ни одна* не знала о взаимодействии. Обычно сложнее Gateway; в enterprise почти всегда про БД (Data Mapper). Не то же, что Mediator: клиенты Mediator про него знают |
| Layer Supertype | общая фича у всех объектов слоя (DomainObject, Mapper) — Fowler ставит почти автоматически |
| Separated Interface | разорвать зависимость: фреймворк зовёт приложение; домен зовёт Data Mapper; чужой API. Интерфейс на каждый класс Fowler считает лишним |
| Registry | известная точка достать «глобальное» (коннекция, finder) без таскать параметр через пять слоёв. Всё равно глобал — Fowler не любит; для mutable в многопотоке не singleton, а thread-scoped |
| Value Object | равенство по значению, не по identity; мелкий объект дёшево создать (Money, DateRange). В БД — Embedded Value. Не путать с DTO: у Alur «value object» = DTO |
| Money | почти все денежные расчёты в ОО: округление, валюта, не float. Сложение разных валют — ошибка или money bag; делёж пенни — allocator, не «просто multiply» |
| Special Case | одно и то же поведение после проверки на конкретный экземпляр или на null (Null Customer). Часто flyweight |
| Plugin | разная реализация от runtime-окружения (тест vs прод), конфиг в одном месте, без пересборки. Пара к Separated Interface |
| Service Stub | зависимость от внешнего сервиса тормозит разработку и тесты. XP зовут Mock Object; Fowler оставляет старое имя |
| Record Set | среда уже крутится вокруг табличного набора (UI-биндинг, ADO.NET). Тогда Table Module: БД → Record Set → модуль → UI → обратно. Без такого тулинга паттерн слабее |

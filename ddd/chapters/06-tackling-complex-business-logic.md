# Глава 6. Tackling Complex Business Logic

- **PDF:** 101–124 (печать 75–98)
- **Якоря:** Domain Model, value object, entity, aggregate, domain event, domain service, Fowler, Evans

**Domain Model** (Fowler) — для сложной логики (правила, инварианты, не CRUD). Evans дал кирпичи; Khononov зовёт их building blocks, не «обязательный tactical DDD». Модель — plain objects без БД и фреймворков, на ubiquitous language.

**Value object** — идентичность по значениям, immutable, режет primitive obsession. **Entity** — нужен Id, состояние меняется; отдельно не живут, только внутри **aggregate**. Aggregate — граница согласованности: снаружи только чтение и команды; одна инстанция на транзакцию БД; внутри иерархия entity + VO. **Domain events** — прошедшее («ticket escalated»), часть публичного интерфейса aggregate. **Domain service** — stateless оркестрация расчётов по нескольким aggregate, не лазейка на multi-aggregate транзакцию. Паттерн для core: инварианты уменьшают degrees of freedom.

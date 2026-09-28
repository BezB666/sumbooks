# Глава 13. Object-Relational Metadata Mapping Patterns

- **PDF:** 330–353 (печать 305–328)
- **Якоря:** Metadata Mapping, Query Object, Repository

Повторяющийся handwritten mapping — знак, что пора описать соответствие данными, а не копипастой.

| Паттерн | Когда |
|---|---|
| Metadata Mapping | много однотипных соответствий поле↔колонка; коммерческие O/R так и живут. Самописный слой: взвесить каркас vs ещё один ручной маппер; reflection иногда тормозит — мерить |
| Query Object | запросы языком объектов, не SQL. Имеет смысл при Domain Model + Data Mapper + уже есть Metadata Mapping. Если команда спокойно пишет SQL и прячет его в finder’ах — можно без этого |
| Repository | много типов и запросов; клиент не отличает память от БД. Особенно силён при нескольких источниках (in-memory для тестов vs SQL). Критерии ≈ Specification |

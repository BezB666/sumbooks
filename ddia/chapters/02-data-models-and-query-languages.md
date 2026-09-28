# Глава 2. Data Models and Query Languages

- **PDF:** 49–90 (печать 27–68)
- **Якоря:** relational model, document model, NoSQL, schema-on-read, schema-on-write, MapReduce, property graph, Cypher, SPARQL, Datalog

Модель данных задаёт, о чём вообще можно думать. Слои: мир → объекты/API → JSON/таблицы/граф → байты на диске. Исторически дерево (hierarchical) плохо для many-to-many → реляционная модель (Codd): оптимизатор запросов один раз, приложения пользуются. NoSQL разошёлся в две стороны: **document** (самодостаточные деревья, связи редки) и **graph** (всё потенциально связано со всем).

Document выигрывает схемой-гибкостью, locality, близостью к коду; relational — joins и many-to-many. Many-to-one в обоих — ссылка (FK vs document reference). RDBMS подтянули JSON, документные — joins: модели сходятся, гибрид нормален. Схема всё равно есть: явная на запись или неявная на чтение.

Языки: SQL декларативный vs императив IMS/CODASYL; MapReduce / aggregation pipeline; для графов Cypher, SPARQL, в фундаменте Datalog. Один size-fits-all не выжил.

# Глава 3. Storage and Retrieval

- **PDF:** 91–132 (печать 69–110)
- **Якоря:** LSM-tree, SSTable, B-tree, OLTP, OLAP, data warehouse, column-oriented storage

Движок надо выбирать под workload. Две школы OLTP-индексов: **log-structured** (только append и удаление старых файлов: SSTable, LSM, Bitcask, Cassandra, Lucene) и **update-in-place** (страницы фиксированного размера: B-tree — почти все RDBMS). Правило большого пальца: LSM быстрее пишет (sequential I/O, compaction в фоне), B-tree — читает (меньше структур проверять). Бенчмарк без своего профиля врёт.

**OLTP** — мало записей по ключу, interactive, bottleneck часто seek. **OLAP** — скан миллионов строк, несколько колонок, агрегаты; bottleneck — bandwidth. С конца 80-х аналитику вынесли в **data warehouse** (star/snowflake), чтобы ad hoc не душило транзакции.

**Column store:** факты широкие, запрос трогает 4–5 колонок — читать только их, плюс сжатие. Data cube / materialized view ускоряют известные агрегаты, сырьё всё равно держат.

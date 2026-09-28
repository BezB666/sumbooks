# Глава 14. Managing Analytical Data (Управление аналитическими данными)

- **PDF:** 677–709 (печать 665–697)
- **Якоря:** operational vs analytical (операционные vs аналитические), Data Warehouse (хранилище данных), Data Lake (озеро данных), Data Mesh (сетка данных), data product quantum (квант продукта данных)

После статус-митинга Dana: операционные БД режем на части, а отчёты и predictive planning надо снова склеить — будет ли warehouse? Logan: смотрели, консолидацию даёт, для нас куча проблем. Операционные данные (эта книга до сих пор) ≠ analytical: другие вопросы, freshness, нагрузка. Warehouse / lake / mesh — ответы разных эпох на «как аналитикам не душить OLTP».

**Data Warehouse** (хранилище): extract → transform в одну схему (часто Star Schema / «звезда») → load. Аналитика живёт только в складе, нагрузка изолирована. Цена: хрупкие пайплайны, потеря domain partitioning (доменное знание растворяется в общей звезде), сложность ETL, sync — узкое место; неполный день данных портит тренды.

**Data Lake** (озеро): load then transform, сырой формат ближе к микросервисам и ML. Меньше up-front модели. Цена: ad hoc transform у каждого потребителя, те же хрупкие пайплайны, stale data.

**Data Mesh** (сетка, Dehghani) — скорее социотехника, чем продукт. Четыре принципа: **domain ownership** (данные принадлежат домену, который их рождает/потребляет, peer-to-peer без обязательного озера), **data as a product** (данные как продукт, которым надо «радовать» потребителей), **self-serve data platform** (платформа: декларативно поднять продукт, поиск, lineage), **computational federated governance** (федеративное управление: privacy, качество, интероп — без одного центрального владельца всех таблиц).

Архитектурное ядро — **data product quantum (DPQ)** рядом с сервисом: source-aligned / aggregate / fit-for-purpose. Связь с аналитикой обычно async, чтобы не тащить operational quantum. Подходит, когда уже есть изоляция доменов (микросервисы). Цена: контракты с DPQ и eventual consistency. Sysops: **ADR — Expert Supply DPQ отдаёт весь день или ничего** (неполный день искажает тренды; fitness function по timestamp’ам; контракт с источниками — loose, чтобы не хрупко).

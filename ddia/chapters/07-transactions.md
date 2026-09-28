# Глава 7. Transactions

- **PDF:** 243–294 (печать 221–272)
- **Якоря:** ACID, BASE, isolation level, read committed, snapshot isolation, lost update, write skew, phantom, 2PL, SSI, serializability

Транзакция — слой, где краш, сеть и гонки схлопываются в abort + retry. NoSQL часто ослабил или выкинул tx; «tx убивают масштаб» и «без ACID нет серьёзных данных» — оба гипербола.

**ACID** (Härder/Reuter, 1983): на практике реализации разные, isolation особенно скользкая; «ACID-compliant» — почти маркетинг. BASE ещё расплывчатее («не ACID»).

Слабые уровни: **read committed** (нет dirty read/write); **snapshot isolation / repeatable read** (MVCC, нет read skew). Lost update — не везде автоматически (иногда `SELECT FOR UPDATE`). **Write skew** и phantoms: решение на устаревшей предпосылке (дежурство врачей); закрывает только serializable. Snapshot не лечит write skew «в контексте phantoms» без index-range locks.

Три пути к serializable: реально по очереди на одном ядре (короткие tx, невысокий throughput); **2PL** (классика, часто бросают из-за производительности); **SSI** — optimistic, без блокировок до commit, abort если не сериализуемо; длинные read-write tx абортятся чаще.

Примеры — реляционная модель, но multi-object tx нужны и без SQL. **Распределённые tx — не здесь**, следующие две главы.

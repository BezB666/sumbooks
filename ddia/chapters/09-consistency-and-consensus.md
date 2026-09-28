# Глава 9. Consistency and Consensus

- **PDF:** 343–410 (печать 321–388)
- **Якоря:** linearizability, total order broadcast, 2PC, consensus, ZooKeeper, compare-and-set

Абстракции, чтобы приложение не видело гл. 8. **Linearizability** (atomic/strong/immediate consistency): иллюзия одной копии, операции атомарны, recency — как только write успешен, все читают новое. Понятно как переменная в одном потоке; дорого при больших задержках сети. Causal consistency слабее: ветвление/слияние, меньше координации.

**Total order broadcast** (atomic broadcast): доставка всем, в одном порядке, даже при сбоях. Не то же самое, что ACID-atomic. Однолидерная репликация даёт порядок, пока лидер жив.

**2PC:** атомарный commit на нескольких нодах (партиции, term-partitioned индекс). На одной ноде решает запись commit-record на диск; разослать «commit» независимо — легко получить half-committed. На практике XA и координаторы имеют свои ямы (блокировка, если координатор умер).

**Consensus** — решить так, чтобы все согласились и решение нельзя отозвать. Сводимы друг к другу: linearizable CAS, atomic commit, TOB, локи/leases, membership, unique constraint. Лидер «отодвигает» консенсус на выборы. **ZooKeeper/etcd** — не general-purpose БД: мало данных в памяти, fault-tolerant TOB, linearizable CAS, zxid как fencing token. HBase, YARN, Kafka сидят на ZK. Leaderless/multi-leader глобальный консенсус часто не используют — и живут с конфликтами.

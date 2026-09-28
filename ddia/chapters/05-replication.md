# Глава 5. Replication

- **PDF:** 173–220 (печать 151–198)
- **Якоря:** leader, follower, synchronous replication, asynchronous replication, replication lag, multi-leader, leaderless, quorum, read-your-writes, monotonic reads

Копия тех же данных на нескольких машинах: ближе к пользователю, жить при падении ноды, масштабировать чтения. Датасет пока целиком на каждой ноде (партиции — гл. 6). Менять реплики трудно; три алгоритма.

**Single-leader:** все записи на лидера, followers применяют лог в том же порядке, клиент читает с любого (followers read-only). Sync: клиент ждёт последователя — меньше потери при failover, один медленный/мёртвый тормозит. Async: быстро, при failover недавно «закоммиченное» может пропасть.

**Replication lag** на async: read-your-writes, monotonic reads, consistent prefix reads — модели, не «eventual» как мантра.

**Multi-leader:** несколько узлов принимают записи (мульти-ДЦ, офлайн). Конфликты; внутри одного ДЦ редко стоит сложности.

**Leaderless** (Dynamo-style: Riak, Cassandra, Voldemort): клиент (или координатор без порядка) пишет/читает несколько реплик; quorum w+r>n. Сбойные ноды чинят read repair / anti-entropy. Конфликты и version vectors — цена.

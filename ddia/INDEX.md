# Designing Data-Intensive Applications — INDEX

Конспекты по [Designing Data-Intensive Applications](../books/designing-data-intensive-applications%20eng.pdf) (Kleppmann, O’Reilly). PDF 613 стр.; печатная страница = PDF − 22. Текст книги в git не копировали.

2-е издание (2025) лежит отдельно: [ddia2/INDEX.md](../ddia2/INDEX.md), сравнение изданий: [ddia2/DIFF-vs-1ed.md](../ddia2/DIFF-vs-1ed.md).

**Как пользоваться:** `py tools/search.py "…" --book ddia` и [corpus/INDEX.md](../corpus/INDEX.md).

Три части: I Foundations (1–4), II Distributed Data (5–9), III Derived Data (10–12).

## Оглавление

| # | Файл | PDF | Печать | Что это |
|---|---|---|---|---|
| 1 | [01-reliable-scalable-maintainable](chapters/01-reliable-scalable-maintainable.md) | 25–48 | 3–26 | reliability ≠ fault-tolerance, масштаб, maintainability |
| 2 | [02-data-models-and-query-languages](chapters/02-data-models-and-query-languages.md) | 49–90 | 27–68 | relational / document / graph, языки запросов |
| 3 | [03-storage-and-retrieval](chapters/03-storage-and-retrieval.md) | 91–132 | 69–110 | LSM vs B-tree, OLTP vs OLAP, column store |
| 4 | [04-encoding-and-evolution](chapters/04-encoding-and-evolution.md) | 133–172 | 111–150 | схемы, REST vs RPC, message-passing |
| 5 | [05-replication](chapters/05-replication.md) | 173–220 | 151–198 | leader/follower, multi-leader, leaderless, lag |
| 6 | [06-partitioning](chapters/06-partitioning.md) | 221–242 | 199–220 | shards, hash vs range, secondary indexes |
| 7 | [07-transactions](chapters/07-transactions.md) | 243–294 | 221–272 | ACID, isolation, write skew, 2PL, SSI |
| 8 | [08-trouble-with-distributed-systems](chapters/08-trouble-with-distributed-systems.md) | 295–342 | 273–320 | delays, clocks, majority, non-Byzantine |
| 9 | [09-consistency-and-consensus](chapters/09-consistency-and-consensus.md) | 343–410 | 321–388 | linearizability, 2PC, consensus, ZooKeeper |
| 10 | [10-batch-processing](chapters/10-batch-processing.md) | 411–460 | 389–438 | Unix, MapReduce, derived data |
| 11 | [11-stream-processing](chapters/11-stream-processing.md) | 461–510 | 439–488 | brokers vs logs, CDC, Event Sourcing |
| 12 | [12-future-of-data-systems](chapters/12-future-of-data-systems.md) | 511–574 | 489–552 | unbundling, derived data, end-to-end |

Glossary / Index — PDF 575–613 (печать 553–591) — не конспектировали.

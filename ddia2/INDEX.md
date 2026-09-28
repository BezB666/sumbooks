# Designing Data-Intensive Applications, 2nd ed. — INDEX

Конспекты по [Designing Data-Intensive Applications, 2nd edition](../books/2nd%20DDIA%20eng.pdf) (Kleppmann, O’Reilly, 2025). PDF 673 стр.; печатная страница = PDF − 24. Текст книги в git не копировали.

**Как пользоваться:** `py tools/search.py "…" --book ddia2` и [corpus/INDEX.md](../corpus/INDEX.md).

Конспект 1-го издания (2017) лежит отдельно: [ddia/INDEX.md](../ddia/INDEX.md). Построчное сравнение изданий: [DIFF-vs-1ed.md](DIFF-vs-1ed.md).

## Что нового во 2-м издании (по предисловию)

- Общий пересмотр под AI-бум и cloud native: векторные индексы (semantic search), DataFrames, batch-подготовка данных для ML, object stores вместо локальных дисков.
- Новые темы: sync engines / local-first, workflow engines / durable execution, formal methods и randomized testing, GraphQL, GDPR и юридический контекст.
- MapReduce объявлен устаревшим — глава batch processing переписана. Глава 10 (Consistency and Consensus) почти полностью переписана. Книга на ~60 страниц длиннее.
- Части (Part I/II/III) убраны; структура и нумерация глав изменены (14 глав вместо 12): новая гл. 1 «Trade-Offs in Data Systems Architecture» и новая гл. 14 «Doing the Right Thing», Partitioning переименована в Sharding, The Future of Data Systems — в A Philosophy of Streaming Systems.

## Оглавление

| # | Файл | PDF | Печать | Что это |
|---|---|---|---|---|
| 1 | [01-trade-offs-in-data-systems-architecture](chapters/01-trade-offs-in-data-systems-architecture.md) | 25–56 | 1–32 | OLTP/OLAP, system of record vs derived data, cloud vs self-host, distributed vs single-node |
| 2 | [02-defining-nonfunctional-requirements](chapters/02-defining-nonfunctional-requirements.md) | 57–88 | 33–64 | latency/percentiles, reliability, scalability, maintainability; case study timelines |
| 3 | [03-data-models-and-query-languages](chapters/03-data-models-and-query-languages.md) | 89–138 | 65–114 | relational/document/graph, Cypher/SPARQL/Datalog, GraphQL, ES/CQRS, DataFrames |
| 4 | [04-storage-and-retrieval](chapters/04-storage-and-retrieval.md) | 139–184 | 115–160 | LSM vs B-tree, column store, full-text, vector embeddings |
| 5 | [05-encoding-and-evolution](chapters/05-encoding-and-evolution.md) | 185–220 | 161–196 | JSON/protobuf/Avro, schema evolution, REST/RPC, durable execution |
| 6 | [06-replication](chapters/06-replication.md) | 221–274 | 197–250 | single/multi-leader, leaderless, quorum, CRDT, local-first |
| 7 | [07-sharding](chapters/07-sharding.md) | 275–300 | 251–276 | hash vs range, hot spots, rebalancing, secondary indexes |
| 8 | [08-transactions](chapters/08-transactions.md) | 301–368 | 277–344 | ACID, isolation levels, write skew, 2PL/SSI, 2PC |
| 9 | [09-trouble-with-distributed-systems](chapters/09-trouble-with-distributed-systems.md) | 369–424 | 345–400 | unreliable networks/clocks, fencing, Byzantine, system models, TLA+ |
| 10 | [10-consistency-and-consensus](chapters/10-consistency-and-consensus.md) | 425–474 | 401–450 | linearizability, CAP, logical clocks, Raft/Paxos, ZooKeeper |
| 11 | [11-batch-processing](chapters/11-batch-processing.md) | 475–510 | 451–486 | Unix, MapReduce, dataflow engines, shuffle, ETL |
| 12 | [12-stream-processing](chapters/12-stream-processing.md) | 511–562 | 487–538 | brokers vs logs, CDC, Event Sourcing, stream joins, exactly-once |
| 13 | [13-philosophy-of-streaming-systems](chapters/13-philosophy-of-streaming-systems.md) | 563–608 | 539–584 | derived data, unbundling, dataflow, end-to-end, trust but verify |
| 14 | [14-doing-the-right-thing](chapters/14-doing-the-right-thing.md) | 609–626 | 585–602 | bias, privacy, surveillance, GDPR, regulation |

Glossary / Index — PDF 627–673 (печать 603–649) — не конспектировали.

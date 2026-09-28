# DDIA: сравнение 1-го и 2-го изданий

1-е изд. (2017, 613 стр. PDF, 12 глав в 3 частях) — [ddia/INDEX.md](../ddia/INDEX.md).
2-е изд. (2025, 673 стр. PDF, 14 глав без частей) — [ddia2/INDEX.md](../ddia2/INDEX.md).

## Глобальные изменения (из предисловия 2-го изд.)

- Книга целиком пересмотрена под два сдвига десятилетия: **AI-бум** (векторные индексы для semantic search, DataFrames, batch-подготовка обучающих данных) и **cloud native** (object stores вместо локальных дисков, storage/compute disaggregation — вплетено по всей книге).
- Добавлены темы: **sync engines / local-first**, **workflow engines / durable execution**, **formal methods / randomized testing**, **GraphQL**, **GDPR** и юридический контекст.
- MapReduce объявлен устаревшим — глава batch processing переписана; глава Consistency and Consensus «почти полностью переписана для ясности».
- Структура: **части (Part I/II/III) убраны**, главы перенумерованы, 14 вместо 12. Новая гл. 1 «Trade-Offs in Data Systems Architecture» (общая рамка: OLTP/OLAP, system of record vs derived data, cloud vs self-hosting), новая гл. 14 «Doing the Right Thing» (этика выросла из раздела старой гл. 12 в отдельную главу). Partitioning → **Sharding**, The Future of Data Systems → **A Philosophy of Streaming Systems**.
- Книга на ~60 страниц длиннее; ссылки на литературу вынесены в репозиторий ddia2-references.

## Карта соответствия глав

| 1-е изд. (12 гл.) | PDF | 2-е изд. (14 гл.) | PDF | Характер изменений |
|---|---|---|---|---|
| — | | **1. Trade-Offs in Data Systems Architecture** | 25–56 | новая глава |
| 1. Reliable, Scalable, and Maintainable Applications | 25–48 | 2. Defining Nonfunctional Requirements | 57–88 | переработана, case study timelines |
| 2. Data Models and Query Languages | 49–90 | 3. Data Models and Query Languages | 89–138 | + GraphQL, Event Sourcing/CQRS, DataFrames |
| 3. Storage and Retrieval | 91–132 | 4. Storage and Retrieval | 139–184 | + cloud warehouses, векторные и многомерные индексы |
| 4. Encoding and Evolution | 133–172 | 5. Encoding and Evolution | 185–220 | + durable execution, event-driven architectures, JSON Schema |
| 5. Replication | 173–220 | 6. Replication | 221–274 | + sync engines/local-first, object storage/ZDA, multi-region |
| 6. Partitioning | 221–242 | 7. Sharding | 275–300 | переименована, + multitenancy, cell-based |
| 7. Transactions | 243–294 | 8. Transactions | 301–368 | + distributed transactions внутри БД, exactly-once |
| 8. The Trouble with Distributed Systems | 295–342 | 9. The Trouble with Distributed Systems | 369–424 | + formal methods, deterministic simulation testing |
| 9. Consistency and Consensus | 343–410 | 10. Consistency and Consensus | 425–474 | почти полностью переписана |
| 10. Batch Processing | 411–460 | 11. Batch Processing | 475–510 | переписана (MapReduce устарел) |
| 11. Stream Processing | 461–510 | 12. Stream Processing | 511–562 | расширена и переработана |
| 12. The Future of Data Systems | 511–574 | 13. A Philosophy of Streaming Systems | 563–608 | переименована, переработана |
| (раздел «Doing the Right Thing» в гл. 12) | 511–574 | **14. Doing the Right Thing** | 609–626 | раздел вырос в отдельную главу |

## Сравнение по главам

### 1. Reliable, Scalable, and Maintainable Applications → 2. Defining Nonfunctional Requirements

- **Структура:** классическая тройка (reliability / scalability / maintainability) сохранена, но глава переименована в «Defining Nonfunctional Requirements» и теперь вводит их как единый словарь требований. Открывающий материал 1-го изд. (data-intensive vs compute-intensive, кирпичи — БД/кеш/поиск/stream/batch) переехал в новую гл. 1.
- **Добавлено во 2-м изд.:** performance как отдельное требование — разбор response time vs throughput vs latency, queueing, retry storm и metastable failure, head-of-line blocking; большой case study про home timeline соцсети (fan-out, materialization, celebrity/celebrity-followers как крайние случаи); перцентили и tail latency amplification, SLO/SLA, данные исследований Google/Bing/Yahoo/Akamai; конкретные цифры отказов железа (HDD 2–5%/год, SSD 0.5–1%/год, ошибки RAM у >1% машин/год), availability zones; Post Office Horizon scandal; shared-memory / shared-disk / shared-nothing и linear scalability; irreversibility как враг evolvability.
- **Убрано / сокращено:** почти ничего — материал не удалён, а расширен и переструктурирован. Мелкая потеря: пример размывания границ инструментов (Redis как очередь, Kafka как durable store) из введения 1-го изд. во 2-м не встречается.
- **Переработано:** reliability переопределена через SLO (failure = система не выполняет SLO); эпиграф Алана Кея переехал из гл. 1 1-го изд. в гл. 2; «человеческий фактор» развёрнут в раздел Humans and Reliability с blameless postmortems; scalability переформулирована через вопросы «как растём / какие ресурсы / где предел» и принципы вместо рецептов; Twitter-пример из «Describing Load» 1-го изд. вырос в case study home timelines.
- **Совпадает:** ядро определений — fault vs failure, SPOF, fault injection/Chaos Monkey, operability/simplicity/evolvability.

### 2. Data Models and Query Languages → 3. Data Models and Query Languages

- **Структура:** сохранена (relational vs document → query languages → graph models), добавлены новые крупные разделы в конце.
- **Добавлено во 2-м изд.:** GraphQL (осознанные ограничения, DoS-защита, поверх любой БД); **Event Sourcing / CQRS** — переехало из гл. 11 1-го изд. (Stream Processing) и развёрнуто в полноценный раздел data model (события как source of truth, read models, детерминизм, GDPR vs immutability); **DataFrames, матрицы и массивы** (Pandas/Spark, one-hot encoding, array databases — мост к ML); star/snowflake и **OBT** (one big table) — переехали сюда из гл. 3 1-го изд. (Storage and Retrieval); раздел «When to Use Which Model» с явным правилом выбора; GQL (ISO-стандарт 2024 на базе Cypher); разбор N+1 problem и ORM-компромиссов; инструменты миграции схем (pt-online-schema-change, gh-ost, pg-osc); современные примеры (LinkedIn-профиль, KùzuDB, Neptune).
- **Убрано / сокращено:** секция «MapReduce как язык запросов» из 1-го изд. исчезла (MapReduce в целом разжалован, остался только в гл. 11); MongoDB aggregation pipeline остался, но упоминается короче.
- **Переработано:** сравнение моделей подано через normalization/denormalization как derived data; convergence (JSON в SQL, join'ы в document DB) переписана под современные системы (Spanner interleaved tables, Oracle multi-table clusters).
- **Совпадает:** ядро — impedance mismatch, schema-on-read/write, document locality, property graph/Cypher/SPARQL/Datalog.

### 3. Storage and Retrieval → 4. Storage and Retrieval

- **Структура:** сохранена (log-structured vs B-tree → column store), аналитическая часть сильно расширена, в конце новые разделы про продвинутые индексы. Вводный материал 1-го изд. про OLTP vs OLAP и data warehousing переехал в новую гл. 1; star/snowflake — в гл. 3.
- **Добавлено во 2-м изд.:** **cloud data warehouses и открытый стек аналитики** (BigQuery/Redshift/Snowflake; Parquet/ORC/Lance/Nimble; Iceberg/Delta; Polaris/Unity catalog) — новый раздел; query compilation (LLVM) как явный контраст к vectorized processing; **многомерные индексы** (R-trees, Bkd, space-filling curves, H3); расширенный full-text (n-grams, Levenshtein automaton, GIN); **vector embeddings** (IVF/HNSW, cosine, Faiss/pgvector) — новый раздел; write amplification как явный критерий; bitmap encoding с roaring bitmaps.
- **Убрано / сокращено:** материал про OLTP-индексы в основном сохранён; часть деталей 1-го изд. (например, сравнение с LSM в Cassandra/Lucene-контексте) сжата в пользу новых тем.
- **Переработано:** раздел in-memory databases переписан (акцент: выигрыш не в отказе от дисковых чтений, а в отказе от кодирования в дисковый формат); OLAP-часть изложена через «от warehouse к компонентам»; compaction strategies (size-tiered vs leveled) и vectorized processing были в 1-м изд. лишь кратко (печ. 79, 99) — во 2-м развёрнуты в полноценные подразделы.
- **Совпадает:** LSM vs B-tree, WAL, SSTables/memtable, column store, materialized views/data cubes — ядро не изменилось.

### 4. Encoding and Evolution → 5. Encoding and Evolution

- **Структура:** сохранена (форматы → dataflow), внутри — крупные добавления.
- **Добавлено во 2-м изд.:** **JSON Schema** как стандарт моделирования (OpenAPI, Schema Registry, pg_jsonschema, MongoDB $jsonSchema; open vs closed content model); zero-copy форматы (Cap'n Proto, FlatBuffers); load balancing / service discovery / service mesh (etcd/ZooKeeper, Istio/Linkerd); **durable execution и workflows** (Temporal, Restate, Airflow/Dagster/Prefect, Camunda/BPMN — exactly-once через durable storage, детерминизм); **event-driven architectures** развёрнуты в отдельный раздел (брокеры от TIBCO до Kafka/Kinesis, queue vs topic, AsyncAPI, actor model — Akka/Orleans/Erlang); FastAPI и gRPC как современные IDL-подходы.
- **Убрано / сокращено:** отдельный разбор Thrift слит с Protocol Buffers (упоминается как родственный формат); Hadoop-контекст Avro (где брать writer's schema) заменён на Kafka + Schema Registry и Espresso.
- **Переработано:** dataflow через БД переписан (data outlives code, LSM-compaction, архив в Avro/Parquet); RPC-раздел дополнен правилом «серверы обновляются раньше клиентов» и версионированием API.
- **Совпадает:** ядро — backward/forward compatibility, rolling upgrade, protobuf field tags, Avro reader/writer schema, 2^53, REST vs RPC — не изменилось.

### 5. Replication → 6. Replication

- **Структура:** сохранена (single-leader → multi-leader → leaderless), внутри значительные добавления.
- **Добавлено во 2-м изд.:** **БД поверх object storage и zero-disk architecture** (WarpStream, Confluent Freight, Bufstream, Redpanda Serverless); **sync engines и local-first** (CRDT vs OT с примером ice→nice!, Automerge/Yjs, Lotus Notes, offline = большая сетевая задержка); **multi-region operation** для leaderless (маршрутизация Cassandra/ScyllaDB, уровни консистентности); раздел «single-leader vs leaderless performance» (request hedging, gray failures); WAL-G/Litestream (архивация лога в object store); явное различие replication ≠ backups; замечание о замене терминологии master–slave; уточнение, что DynamoDB — single-leader на Multi-Paxos, а не Dynamo-style.
- **Убрано / сокращено:** врезка 1-го изд. **«Research on Replication»** (chain replication, связь с consensus) удалена; секции «Limitations of Quorum Consistency» и «Sloppy Quorums and Hinted Handoff» как отдельные заголовки растворены в общем quorum-обсуждении; «Multi-Leader Replication Topologies» сильно сжата; часть рассуждений про таймауты перенесена/развита в гл. 9.
- **Переработано:** конфликты multi-leader поданы через strong eventual consistency и CRDT; version vectors выделены и объяснены подробнее (включая отличие от vector clocks); semi-synchronous было и в 1-м изд., во 2-м закреплено как стандартная схема; инцидент GitHub при failover был уже в 1-м изд. — во 2-м дополнен 30-сек таймаутом и fencing как явной защитой.
- **Совпадает:** ядро — sync vs async, replication lag (read-your-writes / monotonic reads / consistent prefix reads), quorum w+r>n, read repair / hinted handoff / anti-entropy.

### 6. Partitioning → 7. Sharding

- **Структура:** глава переименована (Partitioning → Sharding) и слегка расширена.
- **Добавлено во 2-м изд.:** **sharding для multitenancy** и **cell-based architecture** (resource/permission/fault isolation, GDPR/data residence, per-tenant backup) — новый раздел; термин hot key (celebrity problem, heat management Amazon); варианты consistent hashing (rendezvous, jump consistent hashing); **hash range sharding** (token-диапазоны Cassandra/ScyllaDB 16/256, BigQuery partition key + clustering, Snowflake micro-partitions); pre-splitting; разбор автоматического vs ручного rebalancing с риском cascading failure; этимология термина (Ultima Online); предупреждение о самодельных индексах в коде приложения.
- **Убрано / сокращено:** секция **Parallel Query Execution** (MPP) удалена — осталась одна отсылка к гл. 11; терминология «document-partitioned / term-partitioned» заменена на **local / global secondary index**; трёхчастная «Strategies for Rebalancing» растворена по секциям key range/hash.
- **Переработано:** consistent hashing был в 1-м изд. лишь кратко (и с предупреждением о расплывчатости термина, печ. 204) — во 2-м выделен в отдельный раздел; rebalancing-стратегии переструктурированы (fixed number of shards, hash range, split/merge), request routing подана через coordination service (ZooKeeper/etcd/Raft) vs gossip.
- **Совпадает:** ядро — key range vs hash, skew/hot spots, локальные и глобальные вторичные индексы, mod N.

### 7. Transactions → 8. Transactions

- **Структура:** сохранена и дополнена большим блоком распределённых транзакций, перенесённым из гл. 9 1-го изд.
- **Добавлено во 2-м изд.:** **distributed transactions** целиком: 2PC (prepare/commit, in-doubt, blocking), **XA** и его ямы (orphaned in-doubt transactions, heuristic decisions), **database-internal distributed transactions** (NewSQL: CockroachDB, TiDB, Spanner, FoundationDB — координатор и шарды реплицируются) — весь блок перенесён из гл. 9 1-го изд.; **exactly-once message processing** переехал сюда из гл. 11 1-го изд. и переработан (идемпотентность через таблицу message ID вместо XA); Post Office Horizon как мотивация; сжатая таблица аномалий по уровням изоляции; примеры обновлены (врачи on-call для write skew сохранён).
- **Убрано / сокращено:** из гл. 9 1-го изд. 2PC-материал ушёл, оставив в гл. 10 консенсус; в остальном сокращений почти нет.
- **Переработано:** вступление переориентировано: вместо спора NoSQL-эпохи «транзакции против масштабируемости» — тезис «транзакции = абстракция, снимающая с приложения часть сбоев и гонок», плюс **NewSQL** (CockroachDB, TiDB, Spanner, FoundationDB, YugabyteDB — в 1-м изд. этих систем нет) как доказательство совместимости сильного ACID с sharding'ом; MVCC-раздел развёрнут (txid, inserted_by/deleted_by, copy-on-write B-trees); ACID-буквы разобраны строже (Consistency — пять смыслов, Durability — только risk-reduction); SSI подан через stale MVCC reads и writes affecting prior reads. Глава выросла с 52 до 68 PDF-страниц.
- **Совпадает:** ядро — read committed, snapshot isolation/MVCC, lost update, write skew, phantoms, serial execution, 2PL, SSI.

### 8. The Trouble with Distributed Systems → 9. The Trouble with Distributed Systems

- **Структура:** сохранена (сети → часы → знание/истина/ложь), в конце новый большой раздел проверки корректности, которого в 1-м изд. не было. Глава выросла с 48 до 56 PDF-страниц.
- **Добавлено во 2-м изд.:** **formal methods и randomized testing**: TLA+ / model checking (Gallina, FizzBee; находка про viewstamped replication), **deterministic simulation testing** (FoundationDB/Flow, TigerBeetle, FrostDB, MadSim, Antithesis) — новый раздел; отмена leap seconds с 2035; gray failure / fail-slow / limping node как оформленный класс модели отказов; конкретика по GC-паузам (G1/ZGC/Shenandoah/Epsilon, Rust/Mojo/Swift-ARC); каталог имён fencing-токенов (sequencer/Chubby, epoch/Kafka, ballot/Paxos, term/Raft, FencedLock/Hazelcast) и альтернатива — conditional writes (S3/Azure/GCS preconditions); ClockBound и Amazon Time Sync рядом с TrueTime; fencing-токены в старших битах timestamp для leaderless; новые инциденты (Roblox contention).
- **Убрано / сокращено:** существенных удалений нет; старые примеры (баг HBase с lease, «Sucks to be you», GC как плановый простой) сохранены.
- **Переработано:** многое «новое на вид» было уже в 1-м изд. и во 2-м лишь расширено: Phi Accrual (печ. 306), synchronous vs asynchronous networks с ISDN/ATM/InfiniBand/QoS (добавлен L4S), leap seconds + smearing и MiFID II (печ. 310–312), TrueTime/Spanner ~7 мс и confidence intervals, process pauses и lease-пример, hard real-time, сигналы RST/FIN/ICMP; Chaos Monkey упоминался в 1-м изд. — во 2-м вырос в отдельную тему chaos engineering; «Byzantine faults» дополнен «weak forms of lying» (битые пакеты, санитизация ввода, несколько NTP-серверов).
- **Совпадает:** ядро — partial failures, timeouts и unbounded delays, monotonic vs time-of-day clocks, process pauses/GC, quorum, fencing tokens, system models.

### 9. Consistency and Consensus → 10. Consistency and Consensus

- **Структура:** по предисловию 2-го изд. — «почти полностью переписана»; фактически реструктурирована: linearizability (с CAP/PACELC и ценой) → ID generators → logical clocks → consensus → coordination services. 2PC/atomic commit уехали в гл. 8; материал «Ordering Guarantees» разбит на два новых раздела; CAP вырос из подраздела в отдельный раздел; ZooKeeper стал «Coordination services» и расширен. Объём упал с 68 до 50 PDF-страниц.
- **Добавлено во 2-м изд.:** **ID generators и logical clocks** как отдельный большой раздел: UUID v4/v7, ULID, Flake, MongoDB ObjectID (Snowflake в 1-м изд. — лишь сноска в гл. 8); **hybrid logical clocks** (CockroachDB) и таксономия Lamport / HLC / vector clocks; linearizable ID — **timestamp oracle** (TiDB/TiKV, идея Percolator) и Spanner **TrueTime**; PACELC; эквивалентность consensus-задач (CAS, shared log, fetch-and-add, atomic commit) и **consensus number** (CAS/shared log = ∞, fetch-and-add = 2); epochs (ballot/view/term), два раунда голосований, unclean leader election, EPaxos, pre-vote в Raft, reconfiguration; coordination services дополнены (Chubby, etcd, Consul, observers, BookKeeper).
- **Убрано / сокращено:** раздел atomic commit/2PC удалён (перенесён в гл. 8, осталась одна отсылка «atomic commit эквивалентен consensus») — главная причина сокращения главы; материал про order vs causality сжат и переосмыслен в разделе logical clocks.
- **Переработано:** CAP переписан как критика («unhelpful», «либо C, либо A при partition», узость формального результата); consensus подан от «single-leader done right» через эпохи и кворумы; FLP-результат, strict serializability (Spanner/FoundationDB дают, CockroachDB нет — само определение было в 1-м изд.) и теорема Attiya–Welch были и в 1-м изд. (кратко) — во 2-м развёрнуты и вплетены в общий рассказ; Lamport timestamps и Zab сохранены из 1-го изд.
- **Совпадает:** определение linearizability (sports website Aaliyah/Bryce), её применения (locks, uniqueness, cross-channel), ZooKeeper/etcd как готовый consensus-сервис.

### 10. Batch Processing → 11. Batch Processing

- **Структура:** переписана; MapReduce разжалован из центрального героя в исторический контекст («now largely obsolete»).
- **Добавлено во 2-м изд.:** **object stores** как полноценный раздел (S3/GCS/Azure Blob: immutable objects, отсутствие rename, S3 API как стандарт — в 1-м изд. лишь упоминание в разделе распределённых ФС); **job orchestration** (Kubernetes/YARN: task executors, resource manager, scheduler; fairness vs efficiency, preemption); workflow DAG и schedulers (Airflow, Dagster, Prefect); shuffle internals (файл на reducer, сегменты + merge); secondary sort и sort-merge join подробно; **SQL as lingua franca** (Trino, Hive, Spark, Flink; cost-based optimizers); **DataFrames** (Pandas vs Spark vs Daft, Arrow); use cases как отдельный блок: ETL/ELT (+ data mesh/data contracts), analytics (**data lakehouse** — Iceberg/Unity), **machine learning** (feature engineering, LLM data prep — Ray, Kubeflow, Flyte), **serving derived data** (Kafka + commit-уведомление, bulk-load, Venice).
- **Убрано / сокращено:** раздел «Map-Side Joins» (broadcast hash / partitioned hash / map-side merge joins) удалён целиком; «Handling Skew» (sampling job, Hive skewed join, двухстадийная группировка) удалён; «Comparing Hadoop to Distributed Databases» сжат до пары абзацев вступления; детали MapReduce job execution ужаты до принципа; Pig/Hive/Cascading/Crunch разжалованы из основных API (Pig остался нишевым); Pregel из самостоятельной темы превращён в подраздел ML (BSP: Giraph/GraphX/Gelly); старый список инструментов bulk load (Voldemort, Terrapin, ElephantDB) заменён новыми (TiDB Lightning, RocksDB SST import, Venice).
- **Переработано:** материал «Beyond MapReduce» стал ядром — dataflow engines (Spark/Flink, Dryad) описаны как основной инструмент; сравнение MapReduce vs MPP заменено на «batch и cloud warehouses сходятся».
- **Совпадает:** Unix-tools пример и философия (immutable входы, rerun, derived data) сохранены.

### 11. Stream Processing → 12. Stream Processing

- **Структура:** сохранена (брокеры → БД и потоки → обработка потоков), внутри много добавлений.
- **Добавлено во 2-м изд.:** backpressure/flow control как явный выбор (drop / queue / backpressure); **dead letter queues**; head-of-line blocking в шардированном логе; tiered storage и WarpStream/Bufstream (лог в object storage, сообщения как Iceberg-таблицы); **outbox pattern** и data contracts (Debezium, Kafka Connect, Maxwell); **crypto-shredding** и puncturable encryption для GDPR-удаления; **IVM** (Materialize, RisingWave, ClickHouse, Feldera) и search on streams (Elasticsearch percolator); watermarking детально (DBLog, пороги на продюсера, три timestamp'а для оценки skew часов устройства); session windows; SCD в контексте детерминизма joins; различение actors vs stream processing; стратегии восстановления state (Flink-снапшоты, Kafka Streams log-compacted, VoltDB).
- **Убрано / сокращено:** раздел **Event Sourcing** (commands vs events, снапшоты) удалён из главы — общее введение переехало в гл. 3 («Event Sourcing and CQRS»), в гл. 12 осталось только сравнение CDC vs Event Sourcing; старые CDC-инструменты (Databus, Wormhole, Sherpa, Bottled Water) заменены на GoldenGate, pgcapture, Kafka Connect; сравнение с actor-фреймворками ужато (Storm DRPC остался).
- **Переработано:** fault tolerance подана через microbatching + checkpointing + транзакции фреймворка + idempotence; dual writes объяснены через гонку рис. 12-4 и CDC-решение.
- **Совпадает:** ядро — AMQP/JMS vs log-based брокеры, consumer offsets, CDC vs Event Sourcing, immutability, три типа joins, exactly-once/effectively-once.

### 12. The Future of Data Systems → 13. A Philosophy of Streaming Systems + 14. Doing the Right Thing

- **Структура:** старая итоговая глава разделена надвое. Техническая часть (data integration, unbundling, correctness) → гл. 13, переименованная в «A Philosophy of Streaming Systems»; финальный этический раздел → отдельная новая гл. 14 «Doing the Right Thing».
- **Добавлено во 2-м изд. (гл. 13):** смена рамки: вместо «футуристических спекуляций» 1-го изд. — явная подача «это одна конкретная философия» (эпиграф Фомы Аквинского сохранён); **kappa architecture** (lambda объявлена «fallen out of use», unified через replay + exactly-once + event-time windowing: Beam → Flink/Dataflow); Debezium, «Kafka-протокол как de facto стандарт», IVM-движки; Trino/Hoptimator как федеративные движки.
- **Добавлено во 2-м изд. (гл. 14):** разделы Bias and Discrimination, Responsibility and Accountability, Feedback Loops, Surveillance выделены в самостоятельные (в 1-м изд. — абзацы внутри Predictive Analytics); **algorithmic prison**; recourse для жертв алгоритмов; echo chambers и самоподдерживающиеся петли (кредитный рейтинг → безработица → бедность); алгоритмический сговор цен на немецких заправках; systems thinking; юридическая конкретика GDPR (freely given, specific, informed, unambiguous; legitimate interest; fraud prevention); **data as labor**, data brokers, **toxic asset / «новый уран»**; ACM Code of Ethics и этика как participatory-процесс; новый эпиграф (Prabhu/Birhane, 2020).
- **Убрано / сокращено:** в гл. 13 исчезла футуристическая рамка «как должно быть» 1-го изд.; из этики ничего существенного не удалено — старые темы поглощены новыми разделами.
- **Переработано:** мысленный эксперимент «data → surveillance» и фраза «machine learning — money laundering for bias» были уже в 1-м изд. — во 2-м выделены в отдельные разделы и развёрнуты (микрофоны, смарт-ТВ, тоталитарные режимы; прокси-дискриминация); аналогия с Industrial Revolution и self-regulation сохранены с новой метафорой «данные — загрязнение информационной эпохи» (Шнайер); end-to-end argument пересказан с акцентом на request ID + UNIQUE constraint; примеры enforcing constraints перенумерованы с мелкими правками.
- **Совпадает:** ядро — system of record vs derived data, unbundling/federated databases, end-to-end argument, «не храни derived-состояние как истину».

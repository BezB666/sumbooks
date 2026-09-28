# Глава 11. Batch Processing

- **PDF:** 475–510 (печать 451–486)
- **Якоря:** online vs offline systems, throughput, human fault tolerance, time travel, Unix tools, sorting vs in-memory aggregation, distributed filesystem, HDFS, object stores, job orchestration, workflow DAG, preemption, MapReduce, dataflow engines, shuffle, sort-merge join, secondary sort, SQL, DataFrames, ETL, data lakehouse, machine learning, serving derived data

**Online vs offline**: вся книга до сих пор — про request/response-системы (браузер, API, БД, кеши, поиск): primary metric — response time, нужна fault tolerance ради availability. Batch processing job (offline system) берёт read-only вход и каждый раз заново генерирует выход — derived data: не понравился результат — удалил, поправил логику, перезапустил.

Входы immutable, side effects (записи во внешние БД) исключены; метрика — **throughput**; job может идти минуты-дни, часто по расписанию. Отсюда **human fault tolerance** / **time travel**: откат по багу тривиален (откатил код и пересчитал; либо держи старый выход в другой директории и переключись — time travel есть в object stores и open table formats), тогда как в read/write БД откат кода не чинит уже испорченные данные; минимизация irreversibility ускоряет Agile-разработку.

Минусы batch: выход доступен только после завершения всего job'а; любое изменение входа требует пересчёта всего датасета. Граница online/batch размыта (долгий SQL-запрос похож на batch); batch — ключевой кирпич data integration (ETL); альтернатива — stream processing (гл. 12).

**Unix tools**: пример — анализ NGINX access log: `cat | awk '{print $7}' | sort | uniq -c | sort -r -n | head -n 5` даёт топ-5 страниц; sort ставит одинаковые URL подряд, uniq -c считает повторы. Гигабайты логов за секунды; awk/sed/grep/sort/uniq/xargs закрывают множество анализов.

**Sorting vs in-memory aggregation**: Python-версия держит hash table — рабочее множество зависит от числа *различных* URL и помещается в память; если же оно больше памяти, выигрывает сортировка: сегменты в памяти → на диск → mergesort с последовательным доступом (как в log-structured storage). GNU sort сам спиливается на диск и параллелится по ядрам, bottleneck — чтение с диска. Предел Unix — одна машина.

**Distributed batch = distributed OS**: те же три компонента, что в ОС: storage (файловая система), scheduler, программы, соединённые pipes. **Distributed filesystems (DFS)**: файлы режутся на крупные блоки по машинам (HDFS 128 MB, JuiceFS/object stores 4 MB против ext4 4 KB) — меньше метаданных, ниже overhead seek'а.

Чтение блока — сетевой запрос к data node (HDFS DataNode, glusterfsd), у каждого узла свой page cache; метаданные — NameNode у Hadoop, у DeepSeek 3FS — metadata service поверх FoundationDB; аналог VFS — протокол доступа (S3 API стал стандартом: MinIO, R2, Tigris, B2; FUSE/NFS дают POSIX-интеграцию).

Shared-nothing на commodity hardware против shared-disk NAS/SAN (спецжелезо, Fibre Channel): дешевле, но чаще отказы → репликация блоков либо erasure coding (Reed–Solomon — дешевле полной репликации; аналог RAID, но по обычной сети).

**Object stores** (S3, GCS, Azure Blob, Swift): объект = bucket + key, get/put, объекты immutable — обновление только полным перезаписыванием (append лишь у Azure Blob и S3 Express One Zone); директорий нет — путь часть key, листинг по префиксу как рекурсивный ls, пустых директорий нет; нет hard/symlink'ов, блокировок, атомарного rename (копия + удаление).

KVS — для малых значений и низкой латентности, DFS/object stores — для крупных объектов (полюса сближает S3 Express One Zone). В DFS можно запустить задачу на машине с репликой данных (data locality), в object stores storage и compute разделены — чуть больше сети, но ресурсы масштабируются независимо.

**Job orchestration**: распределённый аналог kernel'а — orchestrator (Kubernetes, Hadoop YARN) из трёх частей: task executors (NodeManager/kubelet — запуск задач, heartbeats, статусы, изоляция через cgroups), resource manager (глобальное состояние кластера; YARN — ZooKeeper, K8s — etcd; централизация = bottleneck) и scheduler (какие задачи на какие ноды; прикладные под-планировщики — ApplicationMaster у YARN, operators у K8s).

Trade-off распределения ресурсов — fairness vs efficiency: gang scheduling простаивает ядрами и рискует deadlock'ом, ожидание свободных ядер грозит starvation'ом, preemption убитых задач бьёт по эффективности; оптимум NP-hard → эвристики: FIFO, DRF, priority queues, quotas, bin packing.

**Workflow (DAG of jobs)**: job'ы связываются через DFS/object store (в Unix pipe — маленький буфер и backpressure; Spark/Flink умеют и прямой обмен между задачами, но типично — запись в файл и чтение следующим job'ом); причины: общий источник данных для разных команд, перенос между инструментами (Spark → HDFS → Trino → S3), смена ключа шардирования между стадиями.

Job-планировщики (YARN, Spark) не ведут цепочки — это делают workflow schedulers Airflow, Dagster, Prefect (сменившие Oozie/Azkaban); 50–100 job'ов в пайплайне — норма.

**Fault handling**: длинный job почти наверняка встретит отказ или preemption (spot/preemptible instances дешевле, но kill'ятся чаще, чем падает железо); спасение — независимость задач и retry на уровне одной задачи, а не всего job'а. MapReduce: промежуточные данные всегда пишутся в DFS до завершения задачи (надёжно, но много I/O); Spark: промежуточное состояние в памяти (spill на локальный диск), в DFS — только финал, потерянное пересчитывается по lineage; Flink: периодические checkpoint'ы.

**MapReduce** (Google, 2004; Hadoop, CouchDB, MongoDB; ныне устарел и в Google не используется): 4 шага — разбить вход на records (Parquet, Avro), mapper извлекает key-value (awk '{print $7}'), неявная сортировка по ключу, reducer получает итератор значений одного ключа (uniq -c). Mapper stateless и параллелен; второй sort (топ по частоте) = второй MapReduce job: mapper готовит данные к сортировке, reducer обрабатывает отсортированное.

Корни в functional programming (map/reduce из Lisp): нет mutable state, вызовы зависят только от переданных данных → свободный параллелизм и повторный вызов при отказе. Минусы: joins вручную, file-based I/O не даёт pipeline'инга между job'ами, новый JVM на задачу.

**Dataflow engines** (Spark, Flink; предки — Dryad, Nephele): весь workflow — один job, операторы произвольные (join, group by), а не чередование map/reduce. Плюсы: сортировка только где нужна; слияние операторов, не меняющих шардирование, в одну задачу; scheduler видит все зависимости → locality-оптимизации (shared memory вместо сети).

Промежуточное состояние в памяти/на локальном диске, а не в DFS; операторы стартуют по мере готовности входа; процессы переиспользуются — те же вычисления заметно быстрее.

**Shuffle** — распределённая сортировка (вход и выход зашардированы; вопреки названию порядок детерминированный, без случайности) — фундамент joins и агрегаций (MapReduce, Spark, Flink, Daft, Dataflow, BigQuery). Каждый mapper пишет локально по файлу на каждый reducer, hash ключа выбирает reducer; внутри файла пары сортируются (сегменты + merge).

Reducers копируют свои файлы и сливают mergesort'ом → одинаковые ключи подряд, reducer вызывается раз на ключ; выход — shards результата в DFS. BigQuery держит shuffle в памяти и выносит во внешние sorting services (быстрее + репликация для resilience).

**Joins and grouping**: shuffle сводит все записи одного ключа в один reducer → join без сети и с памятью O(1). Пример: activity events (fact table) × user profiles (dimension) — оба mapper'а ключуют по user ID (URL и дата рождения), **secondary sort** кладёт запись профиля первой, затем события по времени; reducer держит одну дату рождения и джойнит события — **sort-merge join**; следующий job перешардирует по URL и считает распределение возрастов = group by + агрегация.

**SQL as lingua franca**: после решения операционных проблем фокус сместился на usability; SQL знают все, меньше кода, интерактивный анализ; query engine транслирует SQL в batch job и оптимизирует — cost-based optimizers у Hive, Trino, Spark, Flink, вплоть до перестановки порядка joins. Ниши: Pig (пошаговые пайплайны; наследник — Morel), jq/JMESPath/JSONPath, Gremlin для графов.

**Batch и cloud data warehouses сходятся**: batch взяли SQL + Parquet + оптимизированные движки; BigQuery и Snowflake — масштабируемость, scheduling и shuffle из batch-мира; BigQuery DataFrames, Snowflake Snowpark. Различия: PageRank, сложный ML и multimodal-данные плохо ложатся в SQL; row-by-row вычисления неэффективны на columnar storage; warehouse'ы дороже — большие job'ы выгоднее в Spark/Flink; выбор = cost, convenience, ease of implementation, availability.

**DataFrames**: модель R/Pandas — таблица и вызовы функций вместо одного SQL; локальные DataFrames индексированы и упорядочены, распределённые (Spark, Flink, Daft) — обычно нет (сюрпризы производительности); Pandas eager, Spark лениво строит query plan и оптимизирует; Daft делит вычисления клиент/сервер, Arrow — общая колоночная модель.

**Batch use cases**: везде, где много данных и свежесть не критична: сверка счетов и инвентаря, demand forecasting, тренировка рекомендательных моделей, финансы (ACH в США почти целиком batch).

**ETL/ELT**: фильтры и проекции «embarrassingly parallel»; workflow schedulers дают расписание, retry'и и видимость упавших job'ов; битый файл легко инспектировать, поправить и перезапустить; раньше пайплайны вела одна data engineering команда, теперь data mesh / data contracts / data fabric позволяют командам публиковать данные самим; ETL-трансформации и аналитика делят движки (SparkSQL, Trino, DuckDB).

**Analytics**: OLAP поверх batch + object store; таблицы над файлами — table formats (Iceberg) и каталоги (Unity) = **data lakehouse**; два стиля: pre-aggregation (OLAP cubes/data marts по расписанию; Druid, Pinot) и ad hoc queries (итеративный анализ, важен response time); интеграция с Tableau, Power BI, Looker, Superset.

**Machine learning**: feature engineering, model training (вход — данные, выход — веса), batch inference; Spark MLlib, Flink MLlib; графы — bulk synchronous parallel (BSP, он же Pregel): Giraph, GraphX, Gelly — итеративные joins соседних вершин до сходимости.

LLM data prep (чистка HTML, дедупликация, tokenization/embeddings) — Kubeflow, Flyte, Ray (OpenAI использовал Ray для ChatGPT), интеграции с PyTorch/TensorFlow/XGBoost; эксперименты — Jupyter/Hex notebooks поверх DataFrame API/SQL.

**Serving derived data**: антипаттерн — писать в продовую БД прямо из job'а по записи: медленно, параллельные writer'ы кладут БД, а главное — теряется all-or-nothing гарантия (частичный выход виден, retry дублирует). Правильно — писать в поток (Kafka): последовательные записи, буфер между batch и продом, fan-out многим потребителям, security boundary (DMZ); Elasticsearch, Pinot, Druid, Venice, ClickHouse умеют читать из Kafka.

Поток сам не даёт all-or-nothing: job по завершении шлёт commit-уведомление, потребители держат данные невидимыми до него (как uncommitted transaction в read committed). Альтернатива — собрать новую БД в job'е и bulk-load: TiDB Lightning, Pinot Hadoop import, RocksDB SST import — быстро и атомарное переключение версий, но сложно инкрементально; гибрид — Venice (полный swap + построчные апдейты).

**Summary (полностью)**: Unix-цепочка иллюстрирует базовые примитивы (sort, count); распределённый batch обрабатывает immutable ограниченные входы и производит выход, допуская rerun без side effects; три компонента: orchestration (где и когда), storage, computation.

DFS и object stores управляют крупными файлами через блочную репликацию, кеши и metadata services, доступ — через pluggable API; job orchestrator'ы планируют задачи, ресурсы и сбои, workflow orchestrator'ы ведут DAG job'ов.

Модели: MapReduce (map/reduce), затем dataflow engines Spark/Flink (проще API, лучше перформанс); масштаб даёт shuffle — фундамент group/join/aggregate. Со зрелостью фокус сместился к usability: SQL и DataFrame API делают batch доступнее и оптимизируемее — фреймворк сам решает, как исполнить job на кластере.

Use cases: ETL-пайплайны по расписанию; аналитика (pre-aggregated и ad hoc); ML для подготовки и обработки больших обучающих датасетов; наполнение продовых систем derived-данными через streams или bulk-load. Далее — stream processing: вход unbounded, job никогда не завершается; модели похожи, но бесконечный поток заметно меняет построение систем.

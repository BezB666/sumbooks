# Глава 10. Consistency and Consensus

- **PDF:** 425–474 (печать 401–450)
- **Якоря:** linearizability, CAS, serializability, strict serializability, CAP theorem, PACELC, leader election, fencing tokens, Lamport timestamps, hybrid logical clocks, vector clocks, consensus, FLP, total order broadcast, state machine replication, Raft, Paxos, Zab, ZooKeeper, etcd

Глава сталкивает две философии репликации: **eventual consistency** (репликация видна приложению, конфликты и расхождения разгребает разработчик; удел multi-leader и leaderless систем) и **strong consistency** (система притворяется одним узлом; проще приложению, но дороже и менее терпима к сбоям). Выбор зависит от приложения: офлайн-редактирование обречено на eventual, быстрые надёжные сети оправдывают strong. Дальше в главе — строго сильный путь.

**Linearizability** (atomic / strong / immediate / external consistency) — иллюзия единственной копии данных: операции атомарны, и как только write завершился, любой последующий read видит новое значение. Это гарантия свежести (recency guarantee), а не изоляции.

Пример: спортивный сайт — Aaliyah увидела финальный счёт и крикнула Bryce'у, тот нажал reload, но его запрос ушёл на отставшую реплику и показал «матч ещё идёт». Нарушение — из-за второго канала связи (голос Aaliyah): Bryce знал, что его read случился позже read Aaliyah.

Объект — register (ключ, строка, документ). Операции: Read(x) и Write(x, v), плюс **CAS(x, vold, vnew)** — атомарная условная запись. Read, конкурентный с write, может вернуть старое или новое значение; но после того как один read вернул новое, все следующие обязаны вернуть новое. Каждая операция «срабатывает» атомарно в одной точке (linearization point), и эти точки идут только вперёд во времени.

**Serializability vs linearizability**: serializability — изоляция транзакций над многими объектами (не спасает от stale read и write skew), linearizability — свежесть операций над одним объектом (не знает про транзакции). Вместе = **strict serializability** (strong-1SR): есть у Spanner и FoundationDB; CockroachDB даёт serializability и частичную свежесть, но не strict serializability — нужна дорогая координация. Изоляция и модель консистентности выбираются независимо.

Где linearizability обязательна. **Locks и leader election**: lease обязан доставаться ровно одному узлу, иначе split brain; так работают ZooKeeper, etcd (ZooKeeper линеен на writes, но read может быть stale; etcd v3 даёт линейные read по умолчанию), рецепты — Apache Curator; Oracle RAC ставит линейные локи на каждую дисковую страницу.

**Uniqueness и инварианты**: username, путь к файлу, баланс не уходит в минус, не продать больше товаров/мест, чем есть. Мягкие трактовки (overbooking с компенсацией) линейности не требуют; жёсткие ограничения — требуют. Foreign-key и атрибутные ограничения реализуемы без linearizability.

**Cross-channel timing dependencies**: веб-сервер пишет видео в storage и кладёт задание в очередь; transcoder может прочитать старую версию файла, если storage нелинеен. То же с push-уведомлением и последующей загрузкой данных. Лечится и без linearizability (в духе read-your-writes), но сложнее.

Реализации. Single-leader replication — потенциально линейна, если все read/write идут на лидера и вы точно знаете, кто лидер: «delusional leader» ломает гарантию, асинхронный failover может потерять committed writes; шардинг single-leader не мешает (гарантия однообъектная). Consensus-репликация (Zab в ZooKeeper, Raft в etcd) — линейна при условии, что read проверяет лидерство узла. Multi-leader — не линейна (конкурентные write и конфликты). Leaderless (Dynamo-style) — вероятно, не линейна.

**Quorum не даёт linearizability**: при w + r > n возможна гонка (рис. 10-6): A читает новое значение, а B, чей запрос начался после ответа A, — старое. Спасают синхронный read repair и запись только после чтения свежайшего timestamp кворума (Riak так не делает ради скорости; Cassandra ждёт read repair, но LWW по time-of-day clocks всё равно ломает линейность из-за clock skew). Linearizable CAS на quorum'ах нереализуем — нужен consensus. Вывод: safest — считать leaderless нелинейным.

**CAP theorem** (Eric Brewer, 2000; trade-off известен с 1970-х): при network partition линейная система обязана отключить отрезанные реплики (CP), нелинейная продолжает работать (AP). «Выбери 2 из 3» — плохая формулировка: partitions случаются сами; правильнее «either consistent or available when partitioned». Формальный CAP узок — одна модель консистентности (linearizability), один тип сбоя (partitions; у Google — <8% инцидентов); обобщение **PACELC** (иначе: latency vs consistency) наследует те же проблемы. Книга зовёт CAP «unhelpful»: исторический вклад (импульс NoSQL) — да, практическая польза — почти нет.

Цена linearizability — не только в partitions: даже RAM многоядерного CPU нелинейна (кэши, store buffers; нужны memory barriers) — ради скорости, а не fault tolerance. Теорема Attiya–Welch: время ответа линейных read/write пропорционально неопределённости сетевых задержек — быстрой линейности в сети с переменными задержками не существует; слабые модели намного быстрее.

**ID generators**. Автоинкремент на одном узле линеен (порядок ID = порядок создания), но не fault-tolerant, медленный кросс-регионально и узкое место. Альтернативы: sharded ID, блоки ID, случайные UUID v4, wall-clock timestamp + уникализация — **UUID v7, Snowflake, ULID, Flake, MongoDB ObjectID**. Все уникальны (практически), но порядок не согласован с реальным порядком событий.

**Logical clocks** считают события, а не время. Требования: компактность, уникальность, total order, согласованность с causality. **Lamport timestamps** (Lamport, 1978) — пара (counter, node ID): инкремент при генерации, подтягивание counter'а при получении чужого timestamp. Дают total order, согласованный с happens-before, но не linearizability (узел гарантирует порядок только относительно увиденных им timestamp'ов); counter'ы несвязанных узлов расходятся; физического времени нет.

**Hybrid logical clocks** — физическое время + правило Lamport: монотонны даже при скачках NTP, порядок согласован с causality, нужны лишь примерно синхронные часы (CockroachDB). **Vector clocks** (version vectors) детектируют concurrency (по счётчику на узел), но размер O(числа узлов). Lamport/HLC хороши как transaction ID для snapshot isolation.

Зачем нужен linearizable ID: A сделал аккаунт приватным (accounts DB), затем залил фото (photos DB); с Lamport clock фото может получить меньший timestamp, и snapshot-read постороннего зрителя увидит «стыдное фото». Реализация: один узел с атомарным инкрементом, персистентностью батчами и single-leader replication (timestamp oracle в TiDB/TiKV, идея из Google Percolator); шардить нельзя. Spanner иначе: **TrueTime** — часы с интервалом неопределённости, узел ждёт истечения интервала — линейные timestamp'ы без коммуникации ценой GPS/атомных часов.

Для locks/uniqueness логических часов мало: победитель — наименьший timestamp, но узел не знает, что его timestamp наименьший, пока не услышит всех остальных — при сбое любого узла система встаёт. Нужен consensus.

**Consensus** — узлы договариваются об одном значении. Инстанции: single-value consensus, CAS, shared log (total order broadcast), atomic fetch-and-add, atomic transaction commit — все эквивалентны (решение одной задачи конвертируется в решение любой другой). Алгоритмы: **Viewstamped Replication, Paxos, Raft, Zab** — в non-Byzantine модели (узлы не врут, только падают и тормозят). Byzantine-варианты (<1/3 злонамеренных узлов, блокчейны) — за рамками книги.

**FLP** (Fischer–Lynch–Paterson): детерминированный алгоритм в асинхронной модели не может гарантировать завершение при риске падения узла. Это не «consensus невозможен»: таймауты (подозрение на сбой, пусть иногда ложное) или рандом делают его решаемым — на практике consensus работает.

Свойства single-value consensus: **uniform agreement** (двое не решают по-разному), **integrity** (нельзя передумать), **validity** (решается только предложенное значение; отсекает тривиальное «всегда решай null»), **termination** (не упавшие узлы в итоге решают; liveness, остальные — safety). Termination требует большинства живых узлов (3 узла терпят 1 отказ, 5 — 2); safety-свойства держатся даже при потере большинства.

CAS ↔ consensus: consensus через CAS(null → value) и обратно; **consensus number** у CAS и shared log — ∞, у fetch-and-add — 2. **Shared log / total order broadcast** (atomic broadcast): свойства — eventual append, reliable delivery, append-only, agreement, validity. Это фундамент **state machine replication**: все реплики применяют одни записи в одном порядке (event sourcing, сериализуемые транзакции через упорядоченное исполнение детерминированных процедур); zxid в ZooKeeper — готовый fencing token; append-операции на лог дают счётчик.

От single-leader к consensus: нужен автоматический failover без split brain. Решение — **epochs**: ballot number (Paxos), view number (Viewstamped Replication), term number (Raft); в каждой эпохе лидер уникален, при конфликте побеждает больший номер. Два раунда голосований (выбор лидера и подтверждение каждой записи) кворумом; кворумы должны пересекаться. Это не 2PC: выборы начинает любой узел, достаточно кворума, а не «да» от всех участников.

Тонкости: Raft пускает в лидеры только узел с логом не хуже, чем у большинства; Paxos позволяет любому стать лидером, но заставляет догнать лог. **Unclean leader election** (опция Kafka) ускоряет восстановление ценой отказа от гарантий consensus — риск потери данных. Линейные read тоже требуют кворум-подтверждения лидерства (etcd). Поддерживается reconfiguration (добавление/удаление узлов).

Стоимость consensus: строгое большинство для работы; узлы не добавляют пропускной способности (наоборот); трудная настройка таймаутов (ложные выборы vs долгое восстановление); у Raft — неприятные edge cases с нестабильным линком → добавлена pre-vote фаза; leaderless **EPaxos** устойчивее к плохим узлам. Итог: consensus — «single-leader replication done right»: автофейловер, без потери committed данных и split brain; автофейловер без проверенного consensus-алгоритма, скорее всего, небезопасен.

**Coordination services** — ZooKeeper, etcd, Consul, по образцу Google **Chubby**: немного данных в памяти (дурабельность на диске), репликация consensus-алгоритмом. Не для больших объёмов и высокой скорости записи. Дают: locks/leases (атомарный CAS), **fencing tokens** (zxid/cversion, revision в etcd), failure detection (сессии, heartbeats, **ephemeral nodes**), change notifications (watch вместо поллинга).

Применения: конфигурация (consensus не обязателен, но удобно), раздача работы узлам (leader election, перемещение шардов — атомарные операции + ephemeral nodes + notifications дают автовосстановление), service discovery (для него consensus — overkill: важнее доступность и скорость, лучше кэш/DNS; ZooKeeper observers читают без голосования и терпят stale). Быстро меняющиеся данные туда не кладут (для этого BookKeeper).

**Summary.** Linearizability — формализация strong consistency: данные выглядят одной копией, все операции атомарны; полезна, когда нужно свежее чтение или разрешение гонок (конфликт имён файлов), но медленна при больших сетевых задержках; многие схемы репликации её не дают, хотя выглядят «сильными».

ID-генераторы: одиночный автоинкремент линеен, но не отказоустойчив; распределённые схемы уникальны, но без согласованного порядка; Lamport/hybrid logical clocks дают causality-порядок, но не linearizability.

**Consensus** даёт fault-tolerant линейную репликацию: группа узлов соглашается об одной последовательности операций, и система ведёт себя как один узел. Эквивалентные задачи: linearizable CAS, locks/leases, uniqueness constraints, shared logs (total order broadcast), atomic commit, fetch-and-add. Raft/Paxos — это single-leader replication со встроенными выборами и failover; каждая запись и каждый линейный read подтверждаются кворумом — дорого (особенно кросс-регионально), но неизбежно для сильной согласованности.

Coordination services (ZooKeeper, etcd) построены на consensus и дают locks, leases, failure detection, notifications — если задача сводится к consensus, бери готовый сервис, а не пиши алгоритм сам. Но consensus нужен не всегда: где важнее доступность и скорость, выбирают слабую согласованность с multi-leader/leaderless репликацией — и там пригодятся логические часы.

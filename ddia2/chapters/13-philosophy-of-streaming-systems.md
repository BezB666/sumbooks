# Глава 13. A Philosophy of Streaming Systems

- **PDF:** 563–608 (печать 539–584)
- **Якоря:** derived data, dataflow, system of record, CDC, total order broadcast, unbundling databases, federated database, write path, read path, stream-table join, end-to-end argument, exactly-once, idempotence, duplicate suppression, uniqueness constraint, timeliness vs integrity, compensating transaction, coordination avoidance, trust but verify, auditability

Итоговая, самая «opinionated» глава книги: сводит воедино темы reliability/scalability/maintainability и развивает streaming-идеи главы 12 в целую философию построения приложений.
Эпиграф (Фома Аквинский): корабль существует ради навигации, а не ради собственной сохранности — так и data system существует ради обработки данных, а не ради хранения.

**Data Integration.** Ни один инструмент не покрывает все access patterns, приложения неизбежно склеивают несколько систем.
Ключевой вопрос: куда данные пишутся впервые (**system of record**) и какие представления откуда derived.
Если индекс обновляется только через CDC в том же порядке, он полностью derived из system of record и потому консистентен с ней; прямая запись в обе системы допускает конфликт порядка (рис. 12-4).
Важен принцип тотального порядка (state machine replication), а не выбор CDC vs event sourcing; детерминизм и идемпотентность упрощают восстановление.

**Derived data vs distributed transactions** — одна цель, разные средства: транзакции дают atomic commit и read-your-writes, лог-системы — deterministic retry + idempotence, но асинхронность.
XA дорог и хрупок, поэтому log-based derived data — самое перспективное; глава ищет средний путь между этими крайностями.

**Пределы total ordering:** лимиты одного leader (sharding → порядок между шардами не определён), multi-datacenter, microservices, offline-клиенты.
Total order broadcast = consensus. Causality ловят иначе: logical timestamps, ссылки на id события, которое видел пользователь, conflict resolution (не спасает при внешних side effects) — пример unfriend → message, где зависимость между событиями легко потерять.

**Batch и stream** едины в принципах, различие — bounded vs unbounded данные.
Функциональный стиль: deterministic pure functions, immutable inputs, append-only outputs; асинхронность локализует сбои, тогда как distributed transactions их амплифицируют.
**Reprocessing** — механизм эволюции: как переход железных дорог на standard gauge через dual gauge (третья рельса), старая и новая схема живут рядом как две derived views, пользователей переводят постепенно, всё обратимо.
**Lambda architecture** (batch+speed слои) устарела; unified/**kappa** требует replay, exactly-once и windowing по event time (Apache Beam → Flink, Cloud Dataflow).

**Unbundling Databases.** БД, batch/stream-процессоры и ОС — всё information management; философии Unix (pipes, bytes, низкий уровень) и relational (SQL, транзакции, высокий уровень) спорят с 1970-х; NoSQL — Unix-подход в OLTP.
Два пути композиции: **federated database** / polystore (unifying reads; PostgreSQL foreign data wrappers, Trino) и **unbundled database** (unifying writes через CDC и event logs — Unix-традиция «small tools that do one thing well»).
Выгода — loose coupling: на уровне систем (лог буферизует, fault contained) и на уровне людей (команды независимы).
Unbundling не заменит БД; это breadth, not depth — если хватает одной системы, не переусложняй (преждевременная оптимизация). Debezium, Kafka protocol как de facto стандарт, incremental view maintenance.

**Designing Applications Around Dataflow.** Идеал — электронная таблица: VisiCalc (1979) сам пересчитывает формулы при изменении входа; data system'ам не хватает именно этого.
**Application code as derivation function**: index, full-text, ML-модель, cache — всё derived, но нестандартные функции требуют своего кода (triggers/stored procedures в БД — afterthought).
Принцип «separation of Church and state» (Alonzo Church, lambda calculus без mutable state): логику не в БД, состояние не в приложении; БД сегодня — пассивная shared variable, на изменения которой нельзя подписаться (только polling).
Dataflow требует stable ordering + fault tolerance (потеря одного сообщения = вечный рассинхрон).
Против microservices/REST: курс валют подписывают заранее и хранят локально — «the fastest and most reliable network request is no network request at all», вместо RPC — stream join покупки с обновлениями курса (join, зависящий от времени).

**Observing Derived State.** **Write path** (eager, precomputed, при записи) и **read path** (lazy, при запросе) встречаются в derived dataset — это trade-off работы на запись против работы на чтение.
**Caches/indexes/materialized views** просто сдвигают границу между путями (full-text index vs precomputed ответы на частые запросы vs grep).
Границу можно двигать до клиента: stateful offline clients (on-device state = cache, пиксели экрана = materialized view), push через SSE/WebSockets, consumer offsets работают и для устройств, end-to-end event streams до UI другого устройства (<1 сек).
**Reads are events too**: чтение как event в тот же stream processor = stream-table join запросов с данными; subscribe = persistent join; логирование чтений даёт provenance/causality (что пользователь видел перед решением).
Multishard-запросы через stream processor (Storm DRPC, fraud prevention) — вариант, когда обычные БД упираются в предел.

**Aiming for Correctness.** Ошибки в stateful-системах живут вечно; транзакциям 40 лет, но isolation levels запутаны, Jepsen вскрывает разрывы между обещаниями и поведением.
**End-to-end argument** (Saltzer, Reed, Clark, 1984): функцию можно реализовать корректно только с участием приложений на концах; низкоуровневые механизмы — лишь performance enhancement.
TCP убирает дубликаты в пределах соединения, но COMMIT, потерявший ответ — вне его: неидемпотентный перевод (пример 13-1) спишет $22 вместо $11; реальные банки так не работают.
Решение — **request ID** (UUID из клиента) + UNIQUE constraint (пример 13-2); та же логика для checksums и encryption — нужна end-to-end проверка.
Транзакции (commit/abort) — полезная, но недостаточная абстракция; отказываясь от них, люди переписывают fault tolerance в приложении — и обычно с багами.

**Enforcing Constraints.** Uniqueness требует consensus (leader/Raft; async multi-leader исключён) либо шардирования по уникальному значению: все конфликтующие записи в один shard, stream processor читает последовательно и детерминированно решает, кто был первым (claim username).
Мультишардовый перевод (рис. 13-2): reserve по request ID в shard'е отправителя → события в shard'ы получателя и комиссии → dedup по request ID; atomicity даёт атомарная запись одного события в лог, а не 2PC: deterministic + at-least-once + idempotence дают ту же корректность без атомарного коммита.

**Timeliness vs Integrity** — consistency смешивает два разных требования.
Timeliness: устаревание временно, лечится ожиданием. Integrity: corruption постоянен, лечится проверкой и починкой.
Слоган: «violations of timeliness are allowed under eventual consistency; violations of integrity result in perpetual inconsistency». Опаздывающая строка в выписке — норма; исчезнувшие деньги — катастрофа.
Dataflow-системы decouple их: integrity держат single-message-запись, deterministic derivation, request ID, immutable + reprocessing.
**Loosely interpreted constraints**: overbooking, overdraft, нехватка товара — «извинения» нужны бизнесу и так; **compensating transaction**; стоимость извинения — бизнес-решение, можно писать оптимистично и проверять постфактум.
Отсюда **coordination-avoiding data systems**: multi-datacenter multi-leader, слабая timeliness, сильная integrity; coordination — только там, где откат невозможен.
Свести «извинения» к нулю нельзя — ни за inconsistency, ни за outages, ищи оптимум.

**Trust, but Verify.** System model бинарен, реальность вероятностна; corruption бывает в памяти, на диске, в сети — и баги есть даже в MySQL/PostgreSQL.
ACID consistency предполагает bug-free транзакции. Поэтому **auditing**: HDFS/S3 фоново перечитывают и сверяют реплики; backup'ы надо пробовать восстанавливать.
Event sourcing даёт **auditability**: immutable event + детерминированный перевывод + повторный прогон/параллельный вывод = проверка, provenance, «time-travel debugging».
End-to-end integrity checks дают уверенность и скорость изменений. Инструменты: Merkle trees, certificate transparency, блокчейны (Byzantine fault tolerance; smart contracts = stream processors) — тяжелы, но их криптография применима в лёгком виде.

**Summary:** нет одного инструмента на всё — интегрируем через batch/stream; system of record + derived данные (индексы, views, ML, статистика); асинхронность и loose coupling изолируют сбои; dataflow как трансформации даёт эволюцию (rerun/перевывод) и восстановление — по сути это unbundling базы данных.
Write path дотягивается до устройства пользователя (UI обновляется, работает offline); корректность достигается без distributed transactions — end-to-end request ID, идемпотентность, асинхронная проверка constraints (ждать проверки или рисковать и извиняться).
Это масштабируемее и ближе к реальным бизнес-процессам; избегая coordination, сохраняем integrity и производительность даже в geo-distributed сценариях; аудиты и техники блокчейнов завершают картину.

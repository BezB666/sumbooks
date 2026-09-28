# Messaging vs RPC

## Алиасы

EN: Messaging, Message Channel, broker, store-and-forward, Remote Procedure Invocation, RPC, File Transfer, Shared Database  
RU: сообщения, очередь, брокер, удалённый вызов, файловый обмен, общая база

## Упоминания

### EIP гл. 2, PDF 63–74

Четыре стиля: File Transfer, Shared Database, RPC, Messaging. Messaging — когда пики, недоступность, pub/sub, разные платформы. RPC — нужен ответ сейчас и обе стороны живы.

### EIP Introduction, PDF 12–29

Сеть ненадёжна и медленная; messaging = send-and-forget + store-and-forward, не иллюзия локального вызова.

### GoF

Не про интеграцию приложений. Observer/Mediator — внутри процесса; EIP поднимает их на каналы.

### Kleppmann — DDIA, гл. 4 и 11

Гл. 4, PDF 133–172: REST — публичные API; RPC — сервисы одной орг.; сеть ≠ локальный вызов. Message-passing: брокер буферит, fan-out, обычно one-way, ответ — другой канал. См. [04-encoding-and-evolution.md](../../ddia/chapters/04-encoding-and-evolution.md).

Гл. 11, PDF 461–510: AMQP/JMS (очередь задач, ack→удалить) vs partitioned log (Kafka-стиль: история, порядок в партиции). См. [11-stream-processing.md](../../ddia/chapters/11-stream-processing.md).

### Fowler — PoEAA, гл. 7

Предпочитает async messaging, в книгу его не кладёт. First Law: не распределять объекты. См. [07-distribution-strategies.md](../../poeaa/chapters/07-distribution-strategies.md).

### Richards/Ford — FSA, гл. 14, PDF 240–278

EDA: **broker** (цепочка через лёгкий брокер, нет центра) vs **mediator** (оркестрирует шаги). Request-based — синхронный оркестратор; EDA — процессоры на событиях. Request-reply и shared DB склеивают кванты. См. [14-event-driven.md](../../fsa/chapters/14-event-driven.md).

## Сводка

Newman гл. 5: RPC привычнее, REST даёт глаголы и HTTP-инфру, брокеры — другой мир. Kleppmann разделяет очередь (удалили после ack) и лог (история). Fowler: не резать домен по процессам. FSA: broker vs mediator — контроль ошибок против decoupling.

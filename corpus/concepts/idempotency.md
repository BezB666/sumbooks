# Идемпотентность

## Алиасы

EN: Idempotent Receiver, idempotent, at-least-once, duplicate, retry, re-send, exactly-once, correlation id, business key, Idempotency-Key, ETag, If-Match, conditional PUT  
RU: идемпотентность, дубликат, повтор, ровно один раз, повторная доставка

## Упоминания

### EIP — Enterprise Integration Patterns

- Гл. 10 Messaging Endpoints, PDF ~415–475, паттерн **Idempotent Receiver**: брокер часто даёт at-least-once; повтор с тем же correlation id / business key не должен менять смысл. См. [10-messaging-endpoints.md](../../eip/chapters/10-messaging-endpoints.md).
- Гл. 12 System Management Example, PDF ~503–527: при failover бюро кредитов нормальное лечение — дослать запрос; дубликаты переживают Idempotent Receiver на бюро и брокере. См. [12-interlude-system-management-example.md](../../eip/chapters/12-interlude-system-management-example.md).
- Introduction: асинхронность требует думать про идемпотентность и таймауты.
- Гл. 14: SOAP/ebMS header (id) как опора для Idempotent Receiver.

HTTP-кеш как способ сделать повтор безопасным в EIP **не разбирается**. Там получатель сообщений, не семантика HTTP.

### GoF

Прямого паттерна «идемпотентность» нет. Рядом по духу: операции, которые можно безопасно повторить, живут в коде получателя, не в Observer/Command как таковых.

### Newman — Building Microservices, 2nd ed.

- Гл. 4, PDF 143 (печать 117): таймаут sync-вызова не говорит, дошёл ли запрос; если retry — нужен разбор идемпотентности в гл. 12.
- Гл. 5, PDF 154 (печать 128): GET в HTTP-спеке читает ресурс идемпотентно; POST создаёт. Экосистема HTTP-прокси (Varnish) рядом, но это инфры трафика, не дедуп записи.
- Гл. 12 Resiliency, PDF 432–433 (печать 406–407): исход **бизнес-операции** не меняется после первого применения. Пример: кредит баллов без ключа заказа — не идемпотентен; с `forPurchase` — да. GET/PUT идемпотентны по спеке **только если сервис так делает**. См. [12-resiliency.md](../../building-microservices/chapters/12-resiliency.md).

Кеш (гл. 13) у Newman — отдельная тема, не способ «сделать retry записи безопасным».

### Khononov — Learning DDD, гл. 9

**Outbox:** состояние aggregate и исходящие события в одной транзакции БД; relay публикует; at-least-once → дедуп на потребителе. См. [09-communication-patterns.md](../../ddd/chapters/09-communication-patterns.md).

### Kleppmann — DDIA, гл. 11, PDF 461–510

Exactly-once в книге = **effectively-once**. Как только выход ушёл во внешнюю БД/почту/брокер, retry делает side effect дважды. Нужен атомарный commit всех эффектов или идемпотентная запись. См. [11-stream-processing.md](../../ddia/chapters/11-stream-processing.md).

## Сводка

EIP: дедуп **сообщений** (Idempotent Receiver). Newman: дедуп **вызова** ключом операции + не ломать HTTP-глаголы. Khononov Outbox + дедуп потребителя. Kleppmann: «exactly-once» ломается на границе фреймворка. HTTP-кеш/ETag — про свежесть чтения, см. [http-caching.md](http-caching.md).

# HTTP-кеш и условные запросы

## Алиасы

EN: HTTP cache, Cache-Control, ETag, If-Match, If-None-Match, If-Modified-Since, conditional GET, conditional PUT, freshness, stale  
RU: HTTP-кеш, кеш, условный запрос, свежесть

## Упоминания

### EIP

Channel Adapter может говорить HTTP, но книга **не** учит кешировать ответы, чтобы повтор был идемпотентным. Идемпотентность — Idempotent Receiver (сообщения). См. [idempotency.md](idempotency.md).

### GoF

Нет.

### Newman — Building Microservices, 2nd ed.

- Гл. 5, PDF 154: HTTP даёт экосистему кеш-прокси (Varnish, mod_proxy) — про объём трафика, не про идемпотентную запись.
- Гл. 13 Scaling, PDF 461+ (печать 435+): кеш ради latency / масштаба / иногда устойчивости. HTTP Cache-Control, Expires; **conditional GET** + ETag + `If-None-Match` → 304 Not Modified, чтобы не пересобирать дорогой ответ. Это свежесть чтения. См. [13-scaling.md](../../building-microservices/chapters/13-scaling.md).

Связки «положить ответ POST в HTTP-кеш, чтобы retry не выполнил операцию снова» в книге **нет**.

## Сводка

В проекте HTTP-кеш = Newman гл. 13 (conditional GET / ETag). Идемпотентное **выполнение** = EIP Idempotent Receiver и Newman гл. 12 (ключ операции, глаголы HTTP). Это соседние приёмы, не один.

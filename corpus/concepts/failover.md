# Failover

## Алиасы

EN: failover, Competing Consumers, backup, secondary, Test Message, Smart Proxy, Control Bus  
RU: отказ, запасной, резерв, переключение

## Упоминания

### EIP гл. 10, 11, 12

- Competing Consumers на Point-to-Point: умер один — остальные едят очередь (и балансируют нагрузку). На внешнем SOAP/HTTP без общей очереди не работает.
- Гл. 12: Test Message бьёт primary бюро; консоль (Mediator) переключает роутер на secondary. Сообщения у упавшего primary зависают; лечение — re-send + Idempotent Receiver.

## Сводка

Простой failover = общая очередь + competing consumers. Когда нельзя делить трафик пополам (квоты, разный контракт) — роутер + решение в одном месте, не в мониторе.

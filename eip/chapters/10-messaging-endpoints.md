# Глава 10. Messaging Endpoints (Конечные точки обмена сообщениями)

- **PDF:** стр. 415–475
- **Роль:** как приложение садится на брокер. Отправка простая. Приём — нет. Главная тема приёма: throttling (троттлинг / ограничение темпа).
- **Якоря:** Messaging Gateway (шлюз), Messaging Mapper (маппер сообщений), Transactional Client (транзакционный клиент), Polling Consumer (опрашивающий потребитель), Event-Driven Consumer (событийный потребитель), Competing Consumers (конкурирующие потребители), Message Dispatcher (диспетчер), Selective Consumer (избирательный потребитель), Durable Subscriber (устойчивый подписчик), Idempotent Receiver (идемпотентный получатель), Service Activator (активатор сервиса), duplicate (дубликат), at-least-once (минимум один раз), correlation id (идентификатор корреляции)

Большая часть приложения не должна знать про JMS/MSMQ. Тонкий слой у границы = endpoint (конечная точка).

## И отправитель, и получатель

| Паттерн | Зачем |
|---|---|
| Messaging Gateway (шлюз) | фасад: доменный код зовёт `sendOrder()`, не `MessageProducer` |
| Messaging Mapper (маппер) | объекты приложения ↔ тело сообщения (когда форматы разные; родня Mapper у Fowler) |
| Transactional Client (транзакционный клиент) | send/receive в нашей транзакции: пачка сообщений или сообщение + БД |

По умолчанию каждый send/receive — своя внутренняя транзакция брокера. Внешняя нужна, когда нельзя «сообщение ушло, а commit в БД нет».

## Только получатель

| Паттерн | Как забирает |
|---|---|
| Polling Consumer (опрашивающий) | сам спрашивает «есть?»; темп задаёт приложение |
| Event-Driven Consumer (событийный) | брокер зовёт callback (`onMessage`); удобно, легко захлебнуться |
| Competing Consumers (конкурирующие) | несколько получателей на PTP — масштаб и failover (отказ на запасной) |
| Message Dispatcher (диспетчер) | один слушает, раздаёт в пул воркеров (и на Topic тоже, в отличие от competing) |
| Selective Consumer (избирательный) | API-фильтр брокера (JMS selector): неинтересное даже не получает |
| Durable Subscriber (устойчивый подписчик) | pub/sub: офлайн-подписчик не теряет события |
| Idempotent Receiver (идемпотентный получатель) | повтор доставки не ломает смысл (сеть/гарантии at-least-once / минимум один раз) |
| Service Activator (активатор сервиса) | сообщение → вызов сервиса/метода приложения (в inbound) |

Selective Consumer vs Message Filter (фильтр сообщений; гл. 7): селектор живёт в endpoint; фильтр — отдельный компонент потока.

Competing Consumers на pub/sub = все делают одну работу. Для Topic параллель → Dispatcher (урок гл. 13).

## Throttling (троттлинг)

RPC: сервер не выбирает, как часто клиенты звонят. Messaging: клиенты шлют сколько хотят, сервер забирает сколько тянет, остальное в канале. Polling и ограниченный пул dispatcher — ручка темпа. Event-driven без границы пула — снова шторм.

## Идемпотентность

Гарантия брокера часто «минимум один раз». Дубликаты: тот же correlation id, тот же business key (бизнес-ключ). Receiver должен пережить повтор (гл. 12: failover с re-send опирается на это).

## Связанные паттерны

Message Endpoint (гл. 3), Point-to-Point Channel (точка-точка), Publish-Subscribe Channel (публикация-подписка), Message Filter (фильтр), Transaction + Guaranteed Delivery (гарантированная доставка), примеры в гл. 6 и 13

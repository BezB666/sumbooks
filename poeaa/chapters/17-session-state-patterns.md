# Глава 17. Session State Patterns

- **PDF:** 480–489 (печать 455–464)
- **Якоря:** Client Session State, Server Session State, Database Session State

Куда деть session state из гл. 6. Паттерны не исключают друг друга; id сессии почти всегда на клиенте.

| Паттерн | Когда |
|---|---|
| Client Session State | мало полей; нужен максимально stateless сервер, кластер и failover. Клиент упал — данные пропали (пользователь часто и так так думает). Много данных / HTTP — дорого и небезопасно без шифрования |
| Server Session State | проще всего писать; платформа сама persist/passivate (в т.ч. stateful session bean). С удалённым memento переживает краш узла. Affinity и самописный кластер — основная цена |
| Database Session State | сравнить с двумя другими. Выигрыш — stateless сервер, пул, кластер; плата — читать/писать БД на каждый запрос. Если session state нет и каждый запрос уже пишет record data — естественный выбор |

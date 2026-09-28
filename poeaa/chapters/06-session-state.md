# Глава 6. Session State

- **PDF:** 106–111 (печать 81–86)
- **Якоря:** stateless server, session state vs record data, Client/Server/Database Session State, server affinity

«Stateless server» — не без полей, а без смысла между запросами: можно пулить инстансы. Корзина всё равно stateful. **Session state** — только эта сессия, внутри бизнес-транзакции (пока правишь, может быть невалидным). **Record data** — общая БД. Кэш ≠ session state.

Три склада: **Client** (URL/cookie/hidden field) — мало полей ок, много данных и подделка — плохо; **Server** — память или blob по session id, проще писать; **Database** — разложить по таблицам, изоляция от record data отдельная боль. Кластер: migration vs affinity (прокси склеивает IP). Fowler: Server Session State (лучше с удалённым memento) + client для id и мелочи; Database — если failover/кластер и нельзя remote memento.

# Глава 2. Planning a Migration

- **PDF:** 50–91 (печать 33–74)
- **Якоря:** incremental migration, reversible decisions, Event Storming, DDD, cargo cult

МС — не цель. Три вопроса: каких outcomes хотите; какие альтернативы пробовали; как поймёте, что переход работает. Когда плохо: неясный домен (SnapCI слил сервисы обратно), ранние стартапы, customer-installed софт, «нет причины». Reuse как KPI — ловушка (оптимизируете не time-to-market). Инкрементально и **в прод**; big bang нет. Решения — спектр reversible / irreversible (Bezos Type 1/2): схему БД и публичный API откатывать дороже, чем набросок на доске.

Где резать: DDD + **Event Storming** (Brandolini) — совместная модель, не обязательно event-driven система. Сначала куски с малым inbound (Invoicing легче Notification). Чекпоинты: количественные и качественные меры, не sunk cost.

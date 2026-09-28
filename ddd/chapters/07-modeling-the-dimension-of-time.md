# Глава 7. Modeling the Dimension of Time

- **PDF:** 125–142 (печать 99–116)
- **Якоря:** Event Sourcing, event store, event-sourced domain model, projection, audit log

State-таблица показывает «сейчас», не историю (сколько звонков до CONVERTED?). **Event Sourcing** пишет каждое изменение как событие; текущее состояние — проекция. Те же события можно свернуть в поиск, аналитику, «путешествие во времени» (первые N событий). **Event store** — единственный source of truth, append-only, optimistic concurrency по версии. Это не то же, что ES «просто так»: **event-sourced domain model** = Domain Model, где lifecycle aggregate целиком из domain events (загрузить → rehydrate → команда → новые события).

Плюсы: time travel, insight для core, audit (деньги, закон), тонкий optimistic concurrency. Минусы: дороже моделировать. «Лог рядом со стейтом» и «триггер в history» не заменяют: нет гарантии полноты и нет «почему» изменилось. Для запросов почти всегда нужен CQRS (гл. 8).

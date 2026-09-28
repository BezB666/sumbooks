# Глава 15. Event-Driven Architecture

- **PDF:** 259–274 (печать 233–248)
- **Якоря:** event-driven architecture, event, command, event notification, event-carried state transfer, domain event, coupling

**EDA** — компоненты общаются async событиями; это *между* сервисами. **Event sourcing** — *внутри* сервиса. Событие ≠ любое message: **event** уже случилось (прошедшее время), **command** можно отвергнуть.

Три типа (Fowler): **event notification** — «случилось», деталей мало, за подробностями query; **event-carried state transfer** — снимок/дельта для локального кэша; **domain event** — близко к домену продюсера. Подписка потребителей на *внутренние* ES-события CRM → temporal / functional / implementation coupling, distributed mud. Чинить: проекцию в published language продюсера, notification вместо «лейте все события». Heuristics: сеть врёт, Outbox, дедуп, saga/PM; public vs private events; ECST если eventual ok, notification+query если нужен last write.

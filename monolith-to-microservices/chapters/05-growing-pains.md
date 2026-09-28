# Глава 5. Growing Pains

- **PDF:** 224–253 (печать 207–236)
- **Якоря:** ownership, breaking changes, reporting, monitoring, end-to-end tests, orphaned services

Больше сервисов — другой класс боли (не выключатель, а крутилка). Ownership: collective ломается на росте → у крупных орг. почти всегда strong ownership. Breaking changes: контракт; один сервис с двумя контрактами предпочтительнее двух версий процесса. Reporting: данные разъехались — отдельная reporting DB (CDC, views, события). Monitoring: log aggregation, traces, observability (вопросы post-factum, не только заранее известные алерты).

Дальше по шкале: локальный DX (весь зоопарк на ноутбуке не влезет); running too many things → desired state, часто Kubernetes. E2E раздуваются — сужать scope, CDC/Pact, progressive delivery. Global vs local optimization (три БД «команде так удобно»). Resiliency: timeout, circuit breaker, копии. **Orphaned services** — реестр (FT Biz Ops), назначить владельца.

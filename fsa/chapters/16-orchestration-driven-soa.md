# Глава 16. Orchestration-Driven Service-Oriented Architecture (SOA с оркестрацией)

- **PDF:** 312–322 (печать 300–310)
- **Якоря:** Orchestration-Driven SOA (SOA с оркестрацией), business services (бизнес-сервисы), enterprise services (корпоративные сервисы), orchestration engine (движок оркестрации)

Стиль конца 1990-х: дорогие OS/БД, reuse (повторное использование) любой ценой, distributed (распределённое) «предприятие». Слои: **business / enterprise / application / infrastructure services** (бизнес- / корпоративные / прикладные / инфраструктурные сервисы) + **orchestration engine** (движок оркестрации). Домен (CatalogCheckout) размазан по десяткам сервисов и одной схеме — reuse на практике даёт coupling (сцепление).

Самый технически партиционированный general-purpose (общего назначения) стиль; backlash (откат) → МС. Квант = 1: общая БД + оркестратор как гигантская точка связности. **Deployability/testability** (развёртываемость/тестируемость) провальны; **performance** (производительность) плохой (запрос режется по всем ярусам); elasticity/scalability (эластичность/масштабируемость) вендоры тащили ценой сложности. Урок: пределы technical partitioning (технического разбиения) и распределённых транзакций.

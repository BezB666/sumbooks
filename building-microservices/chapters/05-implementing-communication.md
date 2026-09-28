# Глава 5. Implementing Microservice Communication

- **PDF:** 147–200 (печать 121–174)
- **Якоря:** RPC, REST, GraphQL, message broker, HTTP verbs, GET, PUT, POST, idempotent, Varnish, ETag ecosystem, schema, service discovery, API gateway, service mesh, DRY

Технологии: RPC, REST, GraphQL, брокеры. REST поверх HTTP: глаголы из спецификации — GET идемпотентно читает, POST создаёт; экосистема кеш-прокси (Varnish) и балансировщиков. Это **не** глава про кеш как приём идемпотентности — только «HTTP даёт глаголы и кеш-инфру». Схемы, breaking changes, discovery, mesh/gateway, не шарить код библиотек между сервисами вслепую.

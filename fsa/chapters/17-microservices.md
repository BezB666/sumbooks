# Глава 17. Microservices Architecture (Архитектура микросервисов)

- **PDF:** 323–347 (печать 311–335)
- **Якоря:** Microservices (микросервисы), bounded context (ограниченный контекст), independently deployable (независимо развёртываемый), data isolation (изоляция данных), choreography (хореография), orchestration (оркестрация), saga (сага)

Именован рано (Fowler/Lewis, 2014). Философия — DDD **bounded context** (ограниченный контекст): сервис = домен/workflow (поток работ) + свои классы и схема. **Independently deployable** (независимо развёртываемый), свой процесс; **data isolation** (изоляция данных; не шарить БД как интеграцию). Дублирование часто лучше reuse (повторного использования). Транзакции через сервисы — против причины выбора стиля; **saga** (сага) редко. **Choreography** (хореография) vs **orchestration** (оркестрация); choreography чаще из-за perf (производительности).

Domain-partitioned (доменно разбитый), максимум квантов среди современных стилей. Сильные: scalability (масштабируемость), elasticity (эластичность), evolutionary (эволюционность), fault tolerance (отказоустойчивость), современные engineering/DevOps (инженерные практики/DevOps). Слабые: **performance** (производительность; сеть + security / безопасность на каждом endpoint / конечной точке). UI: монолитный фронт или microfrontends (микрофронтенды).

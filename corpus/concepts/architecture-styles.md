# Architecture styles

## Алиасы

EN: architecture style, layered, pipeline, pipes and filters, microkernel, service-based, event-driven, space-based, SOA, microservices  
RU: стиль архитектуры, слои, конвейер, микроядро, сервисная, событийная

## Упоминания

### Richards/Ford — FSA, ч. II, гл. 9–18

**Style** — надстройка UI + backend (именованные отношения компонент). Pattern — локальнее. Монолит vs distributed — развилка до выбора имени.

| Стиль | Суть (книга) | Где слабо |
|---|---|---|
| Layered | n-tier, дёшево и привычно | scale, elasticity |
| Pipeline | pipes and filters | сложные ветвления |
| Microkernel | core + plug-ins | ядро как bottleneck |
| Service-Based | coarse domain services, часто одна БД | elasticity (крупное зерно) |
| Event-Driven | broker vs mediator | testability, consistency (broker) |
| Space-Based | in-memory grid, БД не в hot path | consistency, стоимость |
| Orchestration-Driven SOA | каноническая модель, ESB, reuse | эволюция, coupling |
| Microservices | bounded context + data isolation | network + security на каждом hop |

Service-Based — pragmatic default, когда «Феррари» МС не нужна. Выбор стиля: it depends + характеристики + кванты, не мода. См. [fsa/INDEX.md](../../fsa/INDEX.md).

### Newman, Khononov, Fowler

Newman: МС = независимый деплой. Khononov: МС = bounded context, не один aggregate. Fowler First Law: не распределять объекты. FSA ставит эти стили на одну шкалу рейтингов.

## Сводка

Имя стиля — ярлык набора trade-off’ов. Сначала характеристики и кванты, потом топология. Hard Parts разбирает, *как резать* уже выбранный distributed стиль: [trade-offs.md](trade-offs.md).

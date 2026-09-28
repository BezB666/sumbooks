# Глава 14. Event-Driven Architecture Style (Событийно-управляемый стиль архитектуры)

- **PDF:** 240–278 (печать 228–266)
- **Якоря:** Event-Driven (событийно-управляемый), broker topology (топология брокера), mediator topology (топология медиатора), initiating event (инициирующее событие), processing event (событие обработки), competing consumers (конкурирующие потребители)

Асинхронный distributed (распределённый) стиль (standalone / автономный или внутри МС). Request-based (запросный) — оркестратор синхронно гоняет процессоры; EDA — decoupled (развязанные) процессоры на событиях.

**Broker** (брокер): нет центрального медиатора; цепочка через лёгкий брокер. Плюсы: decoupled (развязанность), scale (масштаб), responsiveness (отзывчивость), perf (производительность), fault tolerance (отказоустойчивость). Минусы: workflow (поток работ), errors (ошибки), recoverability (восстанавливаемость), restart (перезапуск), consistency (согласованность). **Mediator** (медиатор): оркестрирует шаги. Плюсы: контроль, ошибки, recover (восстановление), restart, consistency. Минусы: coupling (сцепление), scale, perf, fault tolerance, сложные workflow. Выбор: контроль ошибок vs скорость.

Технически партиционирован. Кванты: shared DB (общая БД) или request-reply (запрос-ответ; ждать ответ) склеивают процессоры. Рейтинг: **5★** performance (производительность), scalability (масштабируемость), fault tolerance (отказоустойчивость), evolutionary (эволюционность); **simplicity/testability** (простота/тестируемость) низкие (недетерминированные event trees / деревья событий).

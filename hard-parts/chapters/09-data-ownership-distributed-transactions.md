# Глава 9. Data Ownership and Distributed Transactions (Владение данными и распределённые транзакции)

- **PDF:** 400–468 (печать 388–456)
- **Якоря:** data ownership (владение данными), single/common/joint ownership (единоличное/общее/совместное), ACID, BASE, eventual consistency (eventual-согласованность)

БД режут; команда вешает таблицы на сервисы (bounded context). Спор: expert profile. Sydney кладёт таблицу в Ticket Assignment — алгоритм постоянно читает skills/location, «не можем ходить по сети». Addison: пишет в таблицу User Maintenance (наём, навык, локация) → владелец тот, кто **пишет**. Sydney: «пусть User Maintenance коннектится в чужую БД». Это и есть joint ownership без решения: два писателя, два коннекта, квант снова схлопывается.

Правило большого пальца: **кто пишет в таблицу — тот владелец**. Чтение чужих данных — гл. 10, не повод воровать write. Три сценария:

- **single ownership** (единоличное) — просто, цель большинства таблиц;
- **common ownership** (общее) — почти все пишут (часто выносят в отдельный сервис + очередь);
- **joint ownership** (совместное) — несколько писателей. Техники: **Table Split** (разрезать таблицу по смыслу), **Data Domain** (общая схема, оба пишут без удалённого вызова — независимость ценой шире bounded context), **Delegate** (один владелец, остальные просят update), **Service Consolidation** (склеить сервисы, если write нельзя развести). Ownership потом проверяют на реальных workflow, не на ER-диаграмме.

Распределённый запрос **не ACID**. Внутри сервиса локальные транзакции остаются. Между сервисами — **BASE** (Basically Available, Soft state, Eventual consistency). Три паттерна догнать согласованность: Background Synchronization (фон), Orchestrated Request-Based (оркестратор гоняет запросы), Event-Based (события). Sysops: **ADR — single table ownership по bounded context**; **ADR — Survey Service владеет Survey**.

# Глава 10. Distributed Data Access (Распределённый доступ к данным)

- **PDF:** 469–504 (печать 457–492)
- **Якоря:** Interservice Communication (межсервисная коммуникация), Column Schema Replication (репликация колонок схемы), Replicated Caching (реплицированный кеш), Data Domain (домен данных)

Владение expert profile отдали User Management (пишут). Ticket Assignment всё ещё читает skills/location тысячи раз. Addison: «перепиши алгоритм, меньше запросов». Taylen: «никак». REST на каждый lookup — «нельзя». Messaging вместо REST — тот же hop, плюс сложность. Команда ностальгирует по монолиту: distributed «hard», потому что read чужих данных — отдельная задача, не бесплатный SELECT.

Четыре паттерна книги (GraphQL / CQRS как отдельные главы здесь нет):

| Pattern | Что происходит / цена |
|---|---|
| Interservice Communication (межсервисная) | Assignment зовёт User Management. Просто внедрить. Латентность, хуже scale, нет FT (упал сосед — нет данных), нужен контракт |
| Column Schema Replication (репликация колонок) | Нужные колонки копируют в таблицу читателя. Быстро, без вызова. Цена: consistency, кто владеет копией, как синкать |
| Replicated Caching (реплицированный кеш) | In-memory копия у каждого, непрерывный sync. Быстро и согласованнее, чем редкий batch. Плохо при большом объёме и частых update; старт читателя зависит от владельца (надо прогреть) |
| Data Domain (домен данных) | Общая схема на читателя и писателя. Нет вызова и рассинхрона. Шире bounded context, governance, security; снова общий coupling point |

Sysops: **ADR — replicated cache экспертного профиля** (Assignment читает часто, User Management пишет редко относительно чтения). Общий data domain отвергли: разные домены, у Assignment уже другой коннект, не раздувать quantum обратно.

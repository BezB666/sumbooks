# Глава 13. Domain-Driven Design in the Real World

- **PDF:** 227–242 (печать 201–216)
- **Якоря:** brownfield, strangler, ubiquitous language, pragmatic DDD, undercover DDD

Лабораторный greenfield почти не встречается; DDD нужнее brownfield. Это не all-or-nothing. Старт: стратегия компании, subdomain (оргчарт; core часто «ненавидимый легаси, который нельзя заменить»; generic — купленное; supporting — редко трогают). Потом карта текущих кусков как context map: кто владеет, какие кривые интеграции.

Модернизация: думать широко, начинать с логических модулей по subdomain, не big rewrite. Физические BC — где боль (несколько команд в одном коде, конфликтующие модели). Tactical: сначала TS/AR core → state-based aggregate, не сразу ES. **Pragmatic DDD** — решения от домена, даже если не все tactical-паттерны. Если методологию «не продали» — **undercover**: UL в разговорах и коде, границы и транзакции объяснять логикой, не «книга сказала».

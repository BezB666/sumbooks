# Глава 8. Reuse Patterns (Паттерны повторного использования)

- **PDF:** 348–399 (печать 336–387)
- **Якоря:** code replication (репликация кода), shared library (общая библиотека), shared service (общий сервис), sidecar, service mesh (сервисная сетка), orthogonal coupling (ортогональное сцепление), DRY vs WET

Часть II — Putting Things Back Together (сшиваем обратно). Цитата Constantine: резать связный модуль = больше coupling и хуже читаемость. Часть I была про структуру; часть II — про то, как куски снова работают как система: коммуникация, контракты, workflow, транзакции, данные, аналитика.

Сразу конфликт Sysops: Taylen хочет authorization отдельным shared service; Skyler — в общую DLL; Taylen ещё и несколько shared libraries вместо одной. В монолите reuse (повторное использование) — import класса. В distributed каждый shared кусок — точка сцепления, версий и отказа. В микросервисах часто говорят «reuse is abuse» / WET, но полностью без reuse не живут (форматтеры, аудит, security, logging, metrics).

Ценность reuse: абстракция + **медленный rate of change** (темп изменений). ОС и зрелый фреймворк — хорошая цель сцепления. Доменный код, который меняется каждую неделю, — плохая: все потребители едут вместе. Современный reuse часто = платформа с API, а не «общая JAR на всё».

| Option | Когда / цена |
|---|---|
| Code Replication (репликация кода) | статичный one-off / utility; нет общего артефакта и версий; копии разъезжаются |
| Shared Library (общая библиотека) | гомогенный стек, низкая–средняя волатильность; compile-time, версии, deprecation; гранулярность библиотек — отдельный trade-off |
| Shared Service (общий сервис) | полиглот, частые изменения без пересборки всех; латентность, availability, runtime-риск: упал auth — встали все |
| Sidecar / service mesh (сайдкар / сервисная сетка) | **orthogonal operational coupling** (ортогональное операционное сцепление: monitor, auth, discovery, сеть). Sidecar на платформу; риск раздуть и засунуть туда домен |

Sysops: **ADR — sidecar для operational coupling** (домен в sidecar не класть). **ADR — shared library для общей ticketing DB-логики** (гомогенный стек, не отдельный сетевой hop).

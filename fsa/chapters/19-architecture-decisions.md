# Глава 19. Architecture Decisions (Архитектурные решения)

- **PDF:** 364–386 (печать 352–374)
- **Якоря:** ADR (записи архитектурных решений), Covering Your Assets (прикрытие тыла), Groundhog Day (день сурка), Email-Driven Architecture (архитектура по email), last responsible moment (последний ответственный момент)

Решение = собрать факты, обосновать (тех + бизнес: cost / стоимость, time-to-market / время выхода на рынок, UX, strategy / стратегия), записать, донести. Значимо: структура, зависимости, интерфейсы/контракты, construction techniques (техники построения).

Три антипаттерна подряд: **Covering Your Assets** (прикрытие тыла) — боятся решить (лечить last responsible moment / последний ответственный момент + коллаборация с командой); **Groundhog Day** (день сурка) — нет justification (обоснования), спор по кругу; **Email-Driven Architecture** (архитектура по email) — решение в теле письма, нет system of record (системы учёта; в письме только контекст + ссылка; писать тем, кого реально касается).

**ADR** (Architecture Decision Record / запись архитектурного решения; Nygard; ThoughtWorks Radar: adopt / принять): короткий файл (Markdown/AsciiDoc/wiki) на одно решение; ADR-tools.

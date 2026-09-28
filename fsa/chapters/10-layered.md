# Глава 10. Layered Architecture Style (Многослойный стиль архитектуры)

- **PDF:** 186–197 (печать 174–185)
- **Якоря:** Layered (многослойный), n-tier (n-уровневый), layers of isolation (слои изоляции), sinkhole (воронка / «дыра»), accidental architecture (случайная архитектура), architecture by implication (архитектура по умолчанию)

Де-факто стиль: presentation / business / persistence / database (представление / бизнес / персистентность / база данных). Совпадает с Conway (Конвей; UI / backend / DBA). Часто **accidental architecture** (случайная архитектура) / architecture by implication (архитектура по умолчанию) — «просто начали кодить». **Layers of isolation** (слои изоляции): слой знает только соседний; закрытые слои vs sinkhole (воронка; запрос проваливается сквозь все слои без работы).

Квант всегда 1. Рейтинг (1–5★): сильны **cost** (стоимость) и **simplicity** (простота); **reliability** (надёжность) ~3; **testability** (тестируемость) 2 (можно мокать слой); **deployability** (развёртываемость), **elasticity** (эластичность), **scalability** (масштабируемость), **fault tolerance** (отказоустойчивость) низкие (1); **performance** (производительность) 2 — не естественна, нужна ручная параллельность. Рост монолита убивает maintainability/agility (сопровождаемость/гибкость).

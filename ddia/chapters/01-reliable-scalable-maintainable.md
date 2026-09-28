# Глава 1. Reliable, Scalable, and Maintainable Applications

- **PDF:** 25–48 (печать 3–26)
- **Якоря:** reliability, fault-tolerance, fault vs failure, scalability, load parameters, percentiles, maintainability, operability, simplicity, evolvability

Data-intensive ≠ compute-intensive: данные, сложность, скорость изменения. Кирпичи: БД, кеш, поиск, stream, batch. Границы инструментов размываются (Redis как очередь, Kafka как durable store); приложение само склеивает их и становится дизайнером data system.

**Reliability** — продолжать работать правильно, когда всё ломается. Fault (компонент отошёл от спеки) ≠ failure (сервис для пользователя умер). Fault-tolerant / resilient — терпеть *некоторые* классы сбоев, не все. Железо обычно случайное; софт — систематический (баг на всех нодах сразу); люди — главная причина аутеджей. Chaos Monkey: намеренно ломать, чтобы механизм толерантности жил.

**Scalability** — не ярлык «масштабируется / нет», а вопрос: если нагрузка вырастет *так*, что делать. Сначала load parameters, потом перцентили response time (среднее врёт). Scale-up пока можно; distributed stateful — дорого. Универсального «magic scaling sauce» нет.

**Maintainability:** operability (ops видят здоровье и чинят), simplicity (убрать accidental complexity), evolvability (менять под новые требования на уровне всей системы, не только TDD одного файла).

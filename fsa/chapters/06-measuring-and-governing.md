# Глава 6. Measuring and Governing Architecture Characteristics (Измерение и управление характеристиками архитектуры)

- **PDF:** 114–131 (печать 102–119)
- **Якоря:** fitness function (фитнес-функция), cyclomatic complexity (цикломатическая сложность), governance (управление / гайднс), operational measures (операционные меры), process measures (процессные меры)

Проблемы определений: ilities (характеристики на «-ость») «не физика», в одной компании разные смыслы performance (производительности), многие — composite (составные; agility / гибкость = testability / тестируемость + deployability / развёртываемость). Operational (операционные) меры — числа и контекст; structural (структурные) — в т.ч. **cyclomatic complexity** (цикломатическая сложность; McCabe: CC = E − N + 2); process (процессные) — coverage (покрытие), % удачных деплоев.

**Governance** (управление / гайднс) = steer (рулить). **Fitness functions** (фитнес-функции; из Building Evolutionary Architectures / «Построение эволюционных архитектур» / evolutionary computing / эволюционные вычисления): объективная проверка, что характеристика жива — ArchUnit, автотесты, Simian Army как экстремальный пример. Modularity (модульность) важна, но не urgent (срочна) — без автоматики её съедает срочность.

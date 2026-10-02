# Глава 6. Measuring and Governing Architecture Characteristics (Измерение и управление характеристиками архитектуры)

- **PDF:** 114–131 (печать 102–119)
- **Якоря:** fitness function (фитнес-функция), cyclomatic complexity (цикломатическая сложность), governance (управление / гайднс), operational measures (операционные меры), process measures (процессные меры), distance from the main sequence (расстояние до главной последовательности), ArchUnit, JDepend

Проблемы определений: ilities (характеристики на «-ость») «не физика», в одной компании разные смыслы performance (производительности), многие — composite (составные; agility / гибкость = testability / тестируемость + deployability / развёртываемость). Operational (операционные) меры — числа и контекст; structural (структурные) — в т.ч. **cyclomatic complexity** (цикломатическая сложность; McCabe: CC = E − N + 2); process (процессные) — coverage (покрытие), % удачных деплоев.

**Governance** (управление / гайднс) = steer (рулить). **Fitness functions** (фитнес-функции; из Building Evolutionary Architectures / «Построение эволюционных архитектур» / evolutionary computing / эволюционные вычисления): объективная проверка, что характеристика жива — ArchUnit, автотесты, Simian Army как экстремальный пример. Modularity (модульность) важна, но не urgent (срочна) — без автоматики её съедает срочность.

## Distance from the main sequence как fitness function (PDF 126)

Пример книги — **Example 6-3**, и он же ответ на вопрос «зачем вообще считать `D`». Автор берёт **JDepend**, просит у него список пакетов и проверяет каждый на расстояние до главной последовательности:

```java
double ideal = 0.0;
double tolerance = 0.5;  // project-dependent
...
assertEquals("Distance exceeded: " + p.getName(),
             ideal, p.distance(), tolerance);
```

`tolerance` (допуск) — **project-dependent** (зависит от проекта): это и есть место, где архитектор называет цифру, а не инструмент. Рядом, на той же странице, второй пример — проверка отсутствия циклов между пакетами (`jdepend.containsCycles()`), тоже через JDepend.

Смысл: `D` — из тех метрик, которые легко посчитать один раз руками и забыть. Джойн в continuous build превращает её из разового замера в **guarding** (охрану): «trigger-happy developers» (разработчики, палящие не целясь) не занесут цикл или перекос абстракции случайно. Это и есть определение фитнес-функции из книги — защита **important but not urgent** практик.

Метрика и её формулы: [03-modularity.md](03-modularity.md). Карточка концепта: [concepts/distance-from-main-sequence.md](../../corpus/concepts/distance-from-main-sequence.md).

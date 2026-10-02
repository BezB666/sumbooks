# Distance from the main sequence (расстояние до главной последовательности)

## Алиасы

EN: distance from the main sequence, main sequence, D, abstractness, instability, afferent coupling, efferent coupling, Ca, Ce, zone of pain, zone of uselessness, rigid, stable  
RU: расстояние до главной последовательности, главная последовательность, абстрактность, неустойчивость, афферентное сцепление, эфферентное сцепление, зона боли, зона бесполезности

## Что это

Производная метрика структуры кода (Robert C. Martin, из книги по C++ конца 1990-х), которая отвечает на вопрос: **правильно ли соотнесены абстракция и стабильность модуля**. Не считается по одному модулю в вакууме — только по положению относительно идеальной линии.

```
A = доля абстракций            (abstractness)
I = Ce / (Ce + Ca)             (instability; Ce — исходящее, Ca — входящее сцепление)
D = |A + I − 1|                (distance from the main sequence)
```

Обе величины — доли от 0 до 1. Идеальная линия — `A + I = 1`: **чем абстрактнее модуль, тем он должен быть стабильнее**. `D = 0` — идеально, `D` растёт к 1 в двух плохих углах:

| Зона | Где | Что не так |
|---|---|---|
| **Zone of uselessness** (бесполезности) | правый верхний: много абстракций | код неудобно использовать |
| **Zone of pain** (боли) | левый нижний: много конкретики | хрупкий, тяжёлый в поддержке |

Ключевая тонкость: `I ≈ 0` (стабильность) сам по себе не хорош и не плох. Модуль **stable**, если набит абстракциями, и **rigid** (жёсткий), если конкретикой. Поэтому `I` и `A` смотрят только вместе — отсюда и формула.

## Упоминания

### Richards/Ford — FSA, гл. 3 *Modularity*, PDF 70–73 (печать 58–61)

Полный разбор: abstractness (Eq. 3-3), instability (Eq. 3-4), расстояние (Eq. 3-5) и Figure 3-2 «main sequence defines the ideal relationship between abstractness and instability», Figure 3-3 «normalized distance for a particular class». Зоны uselessness / pain — Figure 3-4. См. [03-modularity.md](../../fsa/chapters/03-modularity.md).

### Richards/Ford — FSA, гл. 6 *Measuring and Governing*, PDF 126 (печать 114)

Метрика как **fitness function**: Example 6-3 гоняет **JDepend** по пакетам и проверяет `p.distance()` против `tolerance` (project-dependent). Рядом — проверка отсутствия циклов (`containsCycles()`). Это превращает разовый замер в охрану в continuous build. См. [06-measuring-and-governing.md](../../fsa/chapters/06-measuring-and-governing.md).

### Ford/Richards/Sadalage/Dehghani — Hard Parts, гл. 4 *Architectural Decomposition*, PDF 107–109 (печать 95–97)

Тот же материал, но в контексте решения «резать ли монолит вообще»: abstractness (Eq. 4-1), instability (Eq. 4-2), расстояние (Eq. 4-3), Figure 4-3, зоны uselessness / pain. Вывод книги прикладной — компонент в зоне боли **не чинят до идеала, а обходят**; грязь (Big Ball of Mud) не станет сервисами от желания. См. [04-architectural-decomposition.md](../../hard-parts/chapters/04-architectural-decomposition.md).

### Где метрики нет

Проверено по полному тексту всех книг корпуса: `building-microservices`, `ddd`, `ddia`, `ddia2`, `eip`, `learning-go`, `monolith-to-microservices`, `mythical-man-month`, `poeaa` — термина не содержат. Слово «instability» у Newman и Kleppmann встречается, но в другом смысле (clock instability, system instability под нагрузкой).

## Расхождение между изданиями

**Формула `A` в двух книгах разная:**

- FSA, Eq. 3-3: `A = Σma / Σmc`
- Hard Parts, Eq. 4-1: `A = Σma / (Σmc + Σma)`

Нормировку в 0–1 даёт **только** версия Hard Parts. С формулой FSA величина не ограничена единицей, и `|A + I − 1|` может выйти за отрезок — теряется смысл «расстояния». Считая `D`, берите нормированную версию. Практически: если пакет из 1 интерфейса и 3 классов даёт FSA-шный `A = 0.33` и Hard-Parts-овский `A = 0.25` — это разные точки на графике.

## Сводка

Метрика отвечает на один вопрос: не перекошен ли модуль между абстракцией и стабильностью. Ценна не сама цифра, а два её применения: (1) карта зон боли/бесполезности как аргумент «обходить, а не чинить» перед декомпозицией; (2) фитнес-функция в CI, чтобы перекос не занесли случайно. Меряет связь количественно — в паре с [connascence](../../fsa/chapters/03-modularity.md) (качественная сила связи) даёт полную картину сцепления. Стили: [architecture-styles.md](architecture-styles.md). Кванты и фитнес-функции: [architecture-quantum.md](architecture-quantum.md).

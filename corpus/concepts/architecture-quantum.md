# Architecture quantum и fitness functions

## Алиасы

EN: architecture quantum, independently deployable, architecture characteristics, ilities, fitness function, connascence, synchronous coupling  
RU: квант архитектуры, характеристики архитектуры, фитнес-функция, сцепление

## Упоминания

### Richards/Ford — FSA, гл. 1, 4–7

Гл. 1: архитектура = structure + **characteristics** + decisions + design principles. First Law: everything is a trade-off.

Гл. 4–5: operational / structural / cross-cutting ilities; explicit vs implicit.

Гл. 6, PDF 114–131: **fitness function** (из Building Evolutionary Architectures) — объективная проверка, что характеристика жива (ArchUnit, тесты). См. [06-measuring-and-governing.md](../../fsa/chapters/06-measuring-and-governing.md).

Гл. 7, PDF 132–143: **architecture quantum** — independently deployable artifact с high functional cohesion и **synchronous connascence**. Включает всё, без чего не работает (часто БД). Shared DB → один квант. Sync-вызов связывает operational characteristics. См. [07-scope-of-architecture-characteristics.md](../../fsa/chapters/07-scope-of-architecture-characteristics.md).

### Ford/Richards — Hard Parts, гл. 1–2

Тот же quantum: сервис — часть кванта, не синоним. Static vs dynamic coupling. Fitness functions держат решение в коде; ADR — why. См. [01-what-happens-when-no-best-practices.md](../../hard-parts/chapters/01-what-happens-when-no-best-practices.md).

## Сводка

Квант — граница деплоя + данных + sync-связи, не «сервис на диаграмме». Характеристики меряют fitness functions, не слайдами. Стили: [architecture-styles.md](architecture-styles.md). Метод выбора: [trade-offs.md](trade-offs.md).

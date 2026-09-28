# Software Architecture: The Hard Parts — INDEX

Конспекты по [Software Architecture: The Hard Parts](../books/Software-Architecture-The-Hard-Parts-Modern-Trade-Off-Analyses-For-Distributed-Architectures-16.11.2021.-.pdf) (Ford, Richards, Sadalage, Dehghani). PDF 833 стр. (ebook conversion); печать ≈ PDF − 12 (гл. 1: PDF 13 = печать 1). Текст книги в git не копировали.

**Как пользоваться:** `py tools/search.py "…" --book hard-parts` и [corpus/INDEX.md](../corpus/INDEX.md).

Части: **I Pulling Things Apart** (разбираем; гл. 2–7) — структура, статическое сцепление; **II Putting Things Back Together** (сшиваем; гл. 8–15) — коммуникация, динамическое сцепление. В конспектах EN + RU в скобках.

## Оглавление

| # | Файл | PDF | Печать | Что это |
|---|---|---|---|---|
| 1 | [01-what-happens-when-no-best-practices](chapters/01-what-happens-when-no-best-practices.md) | 13–45 | 1–33 | нет best practices; trade-off; ADR; fitness functions |
| I | — | 46–47 | 34–35 | Pulling Things Apart (разбираем) |
| 2 | [02-discerning-coupling](chapters/02-discerning-coupling.md) | 46–75 | 34–63 | quantum; static / dynamic coupling |
| 3 | [03-architectural-modularity](chapters/03-architectural-modularity.md) | 76–100 | 64–88 | зачем резать монолит |
| 4 | [04-architectural-decomposition](chapters/04-architectural-decomposition.md) | 101–123 | 89–111 | component-based vs tactical forking |
| 5 | [05-component-based-decomposition](chapters/05-component-based-decomposition.md) | 124–231 | 112–219 | шесть паттернов нарезки компонент |
| 6 | [06-pulling-apart-operational-data](chapters/06-pulling-apart-operational-data.md) | 232–317 | 220–305 | data domains; типы БД |
| 7 | [07-service-granularity](chapters/07-service-granularity.md) | 318–347 | 306–335 | integrators vs disintegrators |
| II | — | 348 | 336 | Putting Things Back Together (сшиваем) |
| 8 | [08-reuse-patterns](chapters/08-reuse-patterns.md) | 348–399 | 336–387 | library / service / sidecar / replication |
| 9 | [09-data-ownership-distributed-transactions](chapters/09-data-ownership-distributed-transactions.md) | 400–468 | 388–456 | ownership; ACID vs BASE |
| 10 | [10-distributed-data-access](chapters/10-distributed-data-access.md) | 469–504 | 457–492 | как читать чужие данные |
| 11 | [11-managing-distributed-workflows](chapters/11-managing-distributed-workflows.md) | 505–557 | 493–545 | orchestration vs choreography |
| 12 | [12-transactional-sagas](chapters/12-transactional-sagas.md) | 558–643 | 546–631 | восемь саг; компенсация |
| 13 | [13-contracts](chapters/13-contracts.md) | 644–676 | 632–664 | strict / loose / CDC |
| 14 | [14-managing-analytical-data](chapters/14-managing-analytical-data.md) | 677–709 | 665–697 | warehouse / lake / data mesh |
| 15 | [15-build-your-own-trade-off-analysis](chapters/15-build-your-own-trade-off-analysis.md) | 710–743 | 698–731 | метод: распутать измерения |

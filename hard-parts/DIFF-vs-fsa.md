# FSA vs Hard Parts: что добавлено и чем отличается

**FSA** (2020, Richards & Ford, PDF 589 стр., 24 главы в 3 частях) — [fsa/INDEX.md](../fsa/INDEX.md).
**Hard Parts** (2021, Ford, Richards, Sadalage, Dehghani, PDF 833 стр., 15 глав в 2 частях) — [hard-parts/INDEX.md](../hard-parts/INDEX.md).

Это не новое издание, а **прямой сиквел** тех же авторов (Richards/Ford) — к ним добавились Sadalage (данные) и Dehghani (data mesh), что сразу объясняет сдвиг фокуса к данным. FSA — широкая карта: характеристики + 8 стилей + soft skills. Hard Parts — узкий deep dive в самое трудное: trade-off-анализ **распределённых** архитектур через метафору «разобрать → собрать» (Part I Pulling Things Apart, Part II Putting Things Back Together). FSA отвечает «какой стиль выбрать», Hard Parts — «как разобрать монолит и заново собрать, не потеряв данные и согласованность».

## Сначала — что добавлено (чего в FSA нет вообще)

Это и есть причина читать Hard Parts. Ниже — весь новый материал, по темам.

### 1. Новый аналитический аппарат: static vs dynamic coupling

- **Static / dynamic coupling** (Page-Jones) — [гл. 2](chapters/02-discerning-coupling.md). FSA даёт coupling/connascence (гл. 3), но не это разделение: **static** = как сварено (зависимости, что уедет вместе при изменении), **dynamic** = как зовут в рантайме (протокол, что передают, жёсткость контракта). Это главная новая рамка — она порождает всё остальное.
- **Три оси dynamic coupling** — communication (sync/async) × consistency (atomic/eventual) × coordination (orchestration/choreography). Из этих трёх осей в гл. 12 складывается матрица восьми саг.
- **Architecture quantum** уточнён практическим тестом «что нужно поднять с нуля, чтобы этот кусок *работал*» (включая БД и брокер) и впервые пронизывает всю книгу: общая БД схлопывает кванты, micro-frontend склеивает UI с сервисом обратно. В FSA это одно определение в гл. 7 — здесь это рабочий инструмент.

### 2. Декомпозиция монолита как метод (в FSA — только «компоненты»)

- **Честность про Big Ball of Mud**: паттерны нарезки не к чему применить, если структуры нет; метрики `D` (distance from the main sequence) переиспользуются из FSA гл. 3 как порог «не чинить до идеала, а обходить» — [гл. 4](chapters/04-architectural-decomposition.md).
- **Component-based decomposition vs tactical forking** (De La Torre): выдирать нужное по компонентам или клонировать весь монолит и удалять лишнее — [гл. 4](chapters/04-architectural-decomposition.md).
- **Шесть паттернов компонентной декомпозиции** (Identify and Size, Gather Common Domain Components, Flatten, Determine Dependencies, Create Component Domains, Create Domain Services) + понятие **architecture story** (структурный рефакторинг под характеристику, с fitness function на каждый шаг) — [гл. 5](chapters/05-component-based-decomposition.md). В FSA ничего подобного нет — гл. 8 лишь вводит понятие компонента.
- **Service granularity: disintegrators vs integrators** — когда мельчить (volatility, scale, fault tolerance, security, слабая связность) и когда клеить обратно (ACID между кусками, workflow-челнок, shared code, чужие таблицы) — [гл. 7](chapters/07-service-granularity.md). FSA не даёт метода размера сервиса; здесь явно сказано «SRP слишком субъективен, не метрика».

### 3. Данные — главная новая территория (FSA их почти не трогает)

- **Operational vs analytical data** как источник напряжения, из-за которого БД перестаёт быть «проблемой DBA» и становится архитектурной — [гл. 1](chapters/01-what-happens-when-no-best-practices.md).
- **Data domains**: пять шагов разделения БД + **data disintegrators/integrators** (change control, квоты коннектов, FK/views/triggers как «скрытый монолит через БД») + выбор типа БД (polyglot: relational/key-value/document/column/graph/NewSQL/time-series) — [гл. 6](chapters/06-pulling-apart-operational-data.md).
- **Data ownership**: single / common / joint ownership, правило «кто пишет — тот владелец», техники **Table Split / Data Domain / Delegate / Service Consolidation** — [гл. 9](chapters/09-data-ownership-distributed-transactions.md).
- **BASE vs ACID** и три способа догнать согласованность (Background Synchronization / Orchestrated Request-Based / Event-Based) — [гл. 9](chapters/09-data-ownership-distributed-transactions.md).
- **Distributed data access**: четыре паттерна чтения чужих данных — Interservice Communication / Column Schema Replication / Replicated Caching / Data Domain — [гл. 10](chapters/10-distributed-data-access.md).
- **Analytical data**: Data Warehouse vs Data Lake vs **Data Mesh** (Dehghani: domain ownership, data as a product, self-serve platform, federated governance) + **data product quantum (DPQ)** — [гл. 14](chapters/14-managing-analytical-data.md). В FSA аналитика не рассматривается вовсе.

### 4. Сборка обратно: коммуникация между сервисами

- **Reuse patterns**: code replication / shared library / shared service / sidecar+service mesh, с критерием **rate of change** (медленно меняющийся код — хорошая цель сцепления, доменный код — плохая) — [гл. 8](chapters/08-reuse-patterns.md). В FSA предупреждение про reuse есть только как урок SOA (гл. 16).
- **Orchestration vs choreography** как отдельная глава, с разведением «оркестратор на workflow» ≠ «глобальный ESB» — [гл. 11](chapters/11-managing-distributed-workflows.md). В FSA это одна строка в гл. 17.
- **Transactional Sagas — флагман книги**: восемь паттернов из трёх осей (Epic / Phone Tag / Fairy Tale / Time Travel / Fantasy Fiction / Horror Story / Parallel / Anthology), **Horror Story как антипаттерн**, **compensation** (нет isolation, side effects, может упасть) и альтернатива **state machine** — [гл. 12](chapters/12-transactional-sagas.md). В FSA «saga» упомянута одним словом («редко»).
- **Contracts**: спектр strict → loose, **consumer-driven contracts**, **stamp coupling** (тащить целую структуру «на всякий случай») — [гл. 13](chapters/13-contracts.md). В FSA контракты лишь названы «значимым решением» (гл. 19).

### 5. Сам метод

- **Build your own trade-off analysis**: entangled dimensions → как сцеплены → цена изменения; static coupling diagram; зафиксировать одну ось (часто sync/async) и крутить остальные; сравнения **качественные**, списки **MECE**, **out-of-context trap** (не тащить чужой блог в свой контекст) — [гл. 15](chapters/15-build-your-own-trade-off-analysis.md).
- **Сквозной кейс Sysops Squad / Penultimate Electronics**: в отличие от FSA (несколько независимых katas — Silicon Sandwiches, Going, Going, Gone), здесь одна история, где архитекторы Addison/Austen принимают ADR от главы к главе, и решения накапливаются — это и есть демонстрация метода. Почти каждая глава заканчивается конкретным ADR.

## Что переиспользовано из FSA (можно не перечитывать)

Это не «повтор», а переданный словарь — Hard Parts предполагает его известным и только напоминает:

- **First/Second Law, least worst** (FSA гл. 1 → HP гл. 1): «всё — компромисс», «why важнее how», цель — наименее плохой набор.
- **ADR** (FSA гл. 19 → HP гл. 1, затем каждая глава): короткий файл Context/Decision/Consequences.
- **Fitness functions** (FSA гл. 6 → HP гл. 1 recap, гл. 5 использование): объективная проверка, что характеристика жива.
- **Architecture characteristics / ilities** (FSA гл. 4–5): operational/structural/cross-cutting — в HP это фон, каждой главой движут драйверы (agility = maintainability + testability + deployability), но заново не выводятся.
- **Component, technical vs domain partitioning** (FSA гл. 8 → HP гл. 3–5).
- **Distance from the main sequence** (FSA гл. 3, 6 → HP гл. 4) — **с нюансом**: формула `A` в книгах разная. FSA даёт `A = Σma/Σmc`, Hard Parts — `A = Σma/(Σmc+Σma)`; нормировку 0–1 даёт только версия Hard Parts. Детали — [distance-from-main-sequence.md](../corpus/concepts/distance-from-main-sequence.md).
- **Стили как фон**: Service-Based (ступенька миграции в гл. 4–5), Microservices, EDA, SOA. В частности **broker/mediator из FSA гл. 14 — это «родственники» choreography/orchestration из HP гл. 11**, а SOA из гл. 16 — предостережение против глобального ESB. Но сами стили не пересказываются.

## Карта соответствия глав

| FSA (24 гл.) | Hard Parts (15 гл.) | Характер связи |
|---|---|---|
| 1–2. Законы, trade-offs, мышление | 1. No “Best Practices” | переиспользовано как предпосылка |
| 3. Modularity (coupling/connascence, `D`) | 2. Discerning Coupling; 4. Decomposition | `D` переиспользован; **static/dynamic coupling — новое** |
| 4–5. Characteristics defined / identifying | вся книга (драйверы) | фон, не пересказ |
| 6. Measuring and Governing (fitness functions) | 1, 5 | переиспользовано |
| 7. Scope of Characteristics (quantum) | 2, 6, 9, 14 | переиспользовано и расширено |
| 8. Component-Based Thinking | 3–5 | расширено в целый метод декомпозиции |
| 9. Foundations (monolith vs distributed) | 3 | переиспользовано |
| 10–12. Layered / Pipeline / Microkernel | — | не используются (предполагаются известными) |
| 13. Service-Based | 4–5 | переиспользовано как ступенька миграции |
| 14. Event-Driven (broker/mediator) | 11. Managing Workflows | родственно: broker≈choreography, mediator≈orchestration |
| 15. Space-Based | — | не используется |
| 16. Orchestration-Driven SOA | 11 (ESB как антипаттерн) | отсылка-предостережение |
| 17. Microservices | вся книга | фон; «saga (редко)» → **8 саг** |
| 18. Choosing Style | 15. Trade-Off Analysis | «it depends» расширен в процедуру |
| 19. Architecture Decisions (ADR) | 1 + все главы | переиспользовано |
| 20. Analyzing Risk (matrix/storming) | — | не используется |
| 21–24. Diagramming / Teams / Negotiation / Career | — | нет (вне фокуса книги) |

Главы, **целиком новые** (без аналога в FSA): 5 (шесть паттернов), 6 (операционные данные), 7 (гранулярность), 8 (reuse), 9 (ownership + BASE), 10 (data access), 12 (саги), 13 (контракты), 14 (аналитика), 15 (метод). То есть 10 из 15 глав Hard Parts — материал, которого в FSA нет.

## Резюме одним абзацем

FSA даёт **словарь** (характеристики, квант, стили, ADR, fitness functions) и ответ «что выбрать»; Hard Parts предполагает словарь известным и даёт **процедуру** (trade-off analysis) на самой болезненной территории — когда надо разобрать монолит и заново собрать распределённую систему, не потеряв данные, согласованность и контракты. Читать Hard Parts ради новых инструментов (связка static/dynamic coupling → три оси → восемь саг, data domains/ownership/access, reuse, контракты, data mesh) стоит целиком; ради повторяющейся базы из FSA — достаточно оглавления, она только напоминается.

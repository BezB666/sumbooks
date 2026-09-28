# PoEAA — INDEX

Конспекты по [Patterns of Enterprise Application Architecture](../books/Patterns-of-Enterprise-Application-Architecture-Martin-Fowler.pdf) (Martin Fowler). PDF 559 стр.; печатная страница = PDF − 25. Текст книги в git не копировали. Имена паттернов — английские.

**Как пользоваться:** `py tools/search.py "…" --book poeaa` и [corpus/INDEX.md](../corpus/INDEX.md). Узкий вопрос → Grep по этому файлу или `chapters/`.

## Оглавление

| # | Файл | PDF | Печать | Что это |
|---|---|---|---|---|
| — | [00-introduction](chapters/00-introduction.md) | 26–41 | 1–16 | что такое enterprise application, слои, производительность, форма паттерна |
| 1 | [01-layering](chapters/01-layering.md) | 42–49 | 17–24 | presentation / domain / data source |
| 2 | [02-organizing-domain-logic](chapters/02-organizing-domain-logic.md) | 50–57 | 25–32 | Script / Model / Table Module / Service Layer |
| 3 | [03-mapping-to-relational-databases](chapters/03-mapping-to-relational-databases.md) | 58–79 | 33–54 | Gateway → Mapper, поведение и структура O/R |
| 4 | [04-web-presentation](chapters/04-web-presentation.md) | 80–87 | 55–62 | MVC, view, input controller |
| 5 | [05-concurrency](chapters/05-concurrency.md) | 88–105 | 63–80 | optimistic/pessimistic, ACID, business vs system tx |
| 6 | [06-session-state](chapters/06-session-state.md) | 106–111 | 81–86 | куда деть состояние сессии |
| 7 | [07-distribution-strategies](chapters/07-distribution-strategies.md) | 112–119 | 87–94 | **First Law: don't distribute objects** |
| 8 | [08-putting-it-all-together](chapters/08-putting-it-all-together.md) | 120–133 | 95–108 | как сложить слои; J2EE / .NET срез 2002 |
| 9 | [09-domain-logic-patterns](chapters/09-domain-logic-patterns.md) | 134–167 | 109–142 | Transaction Script, Domain Model, Table Module, Service Layer |
| 10 | [10-data-source-architectural-patterns](chapters/10-data-source-architectural-patterns.md) | 168–207 | 143–182 | Table/Row Data Gateway, Active Record, Data Mapper |
| 11 | [11-object-relational-behavioral-patterns](chapters/11-object-relational-behavioral-patterns.md) | 208–239 | 183–214 | Unit of Work, Identity Map, Lazy Load |
| 12 | [12-object-relational-structural-patterns](chapters/12-object-relational-structural-patterns.md) | 240–329 | 215–304 | Identity Field, FK, inheritance mappings |
| 13 | [13-object-relational-metadata-mapping-patterns](chapters/13-object-relational-metadata-mapping-patterns.md) | 330–353 | 305–328 | Metadata Mapping, Query Object, Repository |
| 14 | [14-web-presentation-patterns](chapters/14-web-presentation-patterns.md) | 354–411 | 329–386 | MVC, Page/Front Controller, views |
| 15 | [15-distribution-patterns](chapters/15-distribution-patterns.md) | 412–439 | 387–414 | Remote Facade, DTO |
| 16 | [16-offline-concurrency-patterns](chapters/16-offline-concurrency-patterns.md) | 440–479 | 415–454 | Offline Lock, Coarse-Grained, Implicit |
| 17 | [17-session-state-patterns](chapters/17-session-state-patterns.md) | 480–489 | 455–464 | Client / Server / Database Session State |
| 18 | [18-base-patterns](chapters/18-base-patterns.md) | 490–535 | 465–510 | Gateway, Money, Plugin, Record Set, … |

Гл. 1–8 — нарратив (выбор). Гл. 9–18 — каталог паттернов. Front matter и back matter не конспектировали.

---

## Каталог паттернов (коротко)

### Domain logic — гл. 9

| Паттерн | Когда |
|---|---|
| Transaction Script | мало логики, процедура на запрос |
| Domain Model | сложные меняющиеся правила |
| Table Module | Record Set в центре платформы (.NET) |
| Service Layer | несколько клиентов и/или несколько транзакционных ресурсов в одном use case |

### Data source — гл. 10

| Паттерн | Когда |
|---|---|
| Table Data Gateway | SQL на таблицу, отдать Record Set; пара к Table Module |
| Row Data Gateway | экземпляр на строку, без доменной логики; пара к Transaction Script |
| Active Record | класс ≈ таблица, сам load/save |
| Data Mapper | модель и схема эволюционируют порознь |

### O/R behavior — гл. 11

| Паттерн | Когда |
|---|---|
| Unit of Work | помнить изменения, один commit |
| Identity Map | одна строка БД = один объект в памяти |
| Lazy Load | не тащить весь граф сразу |

### O/R structure — гл. 12

| Паттерн | Когда |
|---|---|
| Identity Field | объект ↔ строка, свой ключ |
| Foreign Key Mapping | ассоциация не many-to-many |
| Association Table Mapping | many-to-many или нельзя трогать чужие таблицы |
| Dependent Mapping | дети без своей идентичности, только через владельца |
| Embedded Value | Value Object полями в таблице владельца |
| Serialized LOB | куст объектов без SQL внутрь |
| Single Table Inheritance | одна таблица на иерархию (частый старт Fowler) |
| Class Table Inheritance | таблица на каждый класс |
| Concrete Table Inheritance | таблица на каждый конкретный класс |
| Inheritance Mappers | иерархия мапперов параллельно домену |

### O/R metadata — гл. 13

| Паттерн | Когда |
|---|---|
| Metadata Mapping | соответствие поле↔колонка данными, не копипастой |
| Query Object | запрос языком объектов, не SQL |
| Repository | коллекция + критерии; клиент не видит БД |

### Web — гл. 14

| Паттерн | Когда |
|---|---|
| MVC | есть невизуальная логика — отделить модель от UI |
| Page Controller | действие ≈ страница, навигация простая |
| Front Controller | один вход, сложный поток экранов |
| Template View | макет страницы + маркеры (helper, не scriptlet) |
| Transform View | трансформ (XSLT) над данными |
| Two Step View | общий look / мультибренд, один второй этап |
| Application Controller | машина решает порядок экранов |

### Distribution — гл. 15

| Паттерн | Когда |
|---|---|
| Remote Facade | coarse-grained API на границе процесса |
| Data Transfer Object | пачка данных одним remote-вызовом |

**First Law (гл. 7):** не распределять объекты; кластер копий приложения, внутри — локальные интерфейсы.

### Offline concurrency — гл. 16

| Паттерн | Когда |
|---|---|
| Optimistic Offline Lock | конфликт редок; дефолт |
| Pessimistic Offline Lock | конфликт частый или выбрасывать работу нельзя |
| Coarse-Grained Lock | замок на агрегат, не на каждый объект |
| Implicit Lock | каркас сам берёт замок — не забыть |

### Session state — гл. 17

| Паттерн | Когда |
|---|---|
| Client Session State | мало данных, stateless сервер |
| Server Session State | проще писать; memento переживает краш |
| Database Session State | кластер/failover, данные уже табличные |

### Base — гл. 18

| Паттерн | Когда |
|---|---|
| Gateway | неудобный внешний API в одну точку |
| Mapper | ни одна сторона не зависит от склейки |
| Layer Supertype | общее поведение слоя |
| Separated Interface | разорвать зависимость пакетов |
| Registry | известная точка для «глобала» (осторожно с потоками) |
| Value Object | равенство по значению, не identity |
| Money | деньги: не float, округление, валюта |
| Special Case | вместо null-проверок повсюду |
| Plugin | реализация от окружения, конфиг без пересборки |
| Service Stub | внешний сервис мешает тестам |
| Record Set | среда уже табличная (UI-биндинг) |

---

## Когда что: крупные развилки

1. **Домен простой** → Transaction Script + Gateway. **Средний + Record Set** → Table Module + Table Data Gateway. **Сложный** → Domain Model + Data Mapper (+ Unit of Work, Identity Map).
2. **HTML можно** → серверная presentation, MVC. **Нужен rich client** → presentation на клиенте.
3. **Всё в одном процессе** → мелкие интерфейсы. **Граница процесса есть** → Remote Facade + DTO, не резать домен по классам.
4. **Бизнес-транзакция = один запрос** → системная транзакция. **Длиннее** → Optimistic Offline Lock; если провал на commit неприемлем — Pessimistic.

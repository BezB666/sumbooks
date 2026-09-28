# Глава 6. Pulling Apart Operational Data (Разделение операционных данных)

- **PDF:** 232–317 (печать 220–305)
- **Якоря:** data disintegrators (дезинтеграторы данных), data integrators (интеграторы данных), data domain (домен данных), ACID, BASE, CAP, polyglot (полиглот)

Доменные сервисы уже отдельно деплоятся; БД всё ещё одна. Addison зовёт Dana (data architect) и Devon (DBA). Dana: «монолитная БД нормальна, я за неё отвечаю, не трогать». Devon: есть пятишаговый процесс через **data domains** (домены данных), плюс можно подобрать разные типы БД под knowledge base и survey. Конфликт «данные vs архитектура» из гл. 1 здесь становится конкретным: shared DB (общая БД) держит **architecture quantum** (квант) = 1, какие бы процессы ни вынесли.

Баланс двух сил. **Disintegrators** (дезинтеграторы — когда резать данные): change control (кто меняет схему), connection management (квоты коннектов: один сервис ждёт, другой недоиспользует пул), scalability, fault tolerance, quantum, database type optimization (knowledge base ≠ тикеты). **Integrators** (интеграторы — когда держать вместе): связи таблиц (FK, views, triggers) и ACID-транзакции *между* таблицами. Если резать, не сняв связи, получите скрытый монолит через БД.

Пять шагов data domains: 1) анализ и нарезать домены, 2) разложить таблицы по доменам, 3) отдельные коннекты к схемам (ещё на одном сервере), 4) схемы на свои серверы, 5) switch-over (переключение). Cross-domain FK/views снимают (приём из *Refactoring Databases*). Домен ≠ схема: схема — механизм, домен — смысл.

Выбор типа БД — paradox of choice (парадокс выбора). Оси: learning curve, scale/throughput, availability / partition tolerance, consistency (ACID vs BASE / eventual), приоритет чтения или записи. Типы: relational, key-value, document, column family, graph, NewSQL, cloud native, time-series. CAP всплывает рядом с Table Split (гл. 9). Sysops: **ADR — document DB для customer survey** (опрос не обязан жить в той же реляционной схеме, что тикеты).

# Глава 5. Concurrency

- **PDF:** 88–105 (печать 63–80)
- **Якоря:** lost update, inconsistent read, optimistic vs pessimistic, ACID, isolation levels, business vs system transaction, offline concurrency, process-per-request

Авторы: Fowler и David Rice. Пока работа в одной системной транзакции, менеджер транзакций закрывает много дыр. Боль — **offline concurrency** (данные через несколько DB-транзакций) и потоки app-сервера. Базовые порчи: lost update и inconsistent read; correctness vs liveness. Optimistic — конфликт на commit; pessimistic — кто первый взял. Для бизнес-данных автомердж почти не работает. Deadlock в enterprise — простые консервативные схемы. ACID; системную транзакцию не растягивать на несколько HTTP-запросов. Уровни изоляции: serializable → phantoms → unrepeatable reads → dirty reads.

**Business transaction** ≠ **system transaction**. Если влезает в один запрос или можно long transaction — так и делать. Иначе клеить ACID самим: атомарность на финальном Save (Unit of Work); изоляция — паттерны гл. 16 (Optimistic Offline Lock первым). Выбор optimistic/pessimistic — про UX.

App-server: прикладным не давать явные lock/sync. Process-per-request часто лучше thread-per-request у неопытной команды (та же масштабируемость, меньше падений). Свежие объекты на запрос дешевле пула в современных VM; глобалы — thread-scoped Registry.

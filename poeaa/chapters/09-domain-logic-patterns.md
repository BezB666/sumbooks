# Глава 9. Domain Logic Patterns

- **PDF:** 134–167 (печать 109–142)
- **Якоря:** Transaction Script, Domain Model, Table Module, Service Layer, revenue recognition

Сквозной пример главы — revenue recognition: когда деньги можно поставить на книги (word processor сразу; spreadsheet третями today/60/90; database today/30/60).

| Паттерн | Когда |
|---|---|
| Transaction Script | мало логики, нужна скорость старта; процедура на запрос. Дубли между транзакциями — сигнал уходить в Domain Model |
| Domain Model | сложные и меняющиеся правила (валидация, расчёты, выводы). Команде нужен навык объектов. БД — обычно Data Mapper; снаружи можно Service Layer. Простые not-null и пара сумм — скрипт |
| Table Module | табличные данные и Record Set в центре платформы (.NET). Сложную ОО-логику (связи экземпляр–экземпляр, полиморфизм) не тянет — тогда Domain Model |
| Service Layer | несколько видов клиентов и/или ответ use case трогает несколько транзакционных ресурсов. Не нужен, если один клиент (UI) и ответы простые. Fowler любит тонкий фасад; Stafford (автор паттерна) — богатый слой операций |

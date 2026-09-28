# Глава 10. Data Source Architectural Patterns

- **PDF:** 168–207 (печать 143–182)
- **Якоря:** Table Data Gateway, Row Data Gateway, Active Record, Data Mapper

Как домен разговаривает с таблицами. Выбор почти не рефакторится — см. ещё гл. 3 и 8.

| Паттерн | Когда |
|---|---|
| Table Data Gateway | один объект на таблицу/view, SQL в одном месте; отлично с Table Module и Record Set. Для Domain Model Fowler чаще берёт Data Mapper. Удобно, когда result set удобен скрипту; stored procedures часто сами устроены как этот паттерн |
| Row Data Gateway | экземпляр на строку, без доменной логики. Чаще со Transaction Script. Для простой модели тот же объём даёт Active Record; для сложной — Data Mapper |
| Active Record | домен несложный и классы ≈ таблицы: CRUD, выводы и валидация по одной записи. Проще Data Mapper. Коллекции, наследование, богатые связи быстро делают его кашей |
| Data Mapper | схема БД и объектная модель должны эволюционировать порознь (типично богатый Domain Model). Домен не знает таблиц, тесты без БД. Цена — лишний слой относительно Active Record |

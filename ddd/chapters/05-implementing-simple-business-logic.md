# Глава 5. Implementing Simple Business Logic

- **PDF:** 89–100 (печать 63–74)
- **Якоря:** Transaction Script, Active Record, Fowler, CRUD, supporting subdomain

Оба паттерна из Fowler, *Patterns of Enterprise Application Architecture*. **Transaction Script** — процедура на каждый запрос из UI; логика простая и обязана быть транзакцией (всё или ничего). Легко сломать: два UPDATE без общей транзакции, гонки, отсутствие идемпотентности. Место: supporting (ETL/CRUD), адаптер к generic, кусок ACL. Не для core: дубли и рассинхрон правил.

**Active Record** — объект вокруг строки/дерева, CRUD и чуть доменной логики; TS ходит в AR, а не в БД напрямую. Для простой логики на сложной схеме. Khononov не зовёт это «anemic antipattern»: в supporting это нормальный инструмент; Domain Model сюда тащить — accidental complexity. AR — паттерн Fowler, не фреймворк Active Record.

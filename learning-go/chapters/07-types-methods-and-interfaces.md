# Глава 7. Types, Methods, and Interfaces

- **PDF:** 167–204 (печать 143–180)
- **Якоря:** method set, embedding, interface, accept interfaces return structs, nil interface, any

Тип на базе другого — не наследование: нет иерархии, без конверсии не подставишь. Типы — документация. Методы с pointer/value receiver; method set у указателя шире. `iota` для перечислений, с осторожностью к нулю и вставкам. **Embedding ≠ inheritance**: нельзя присвоить внешний тип внутреннему; нет dynamic dispatch у конкретных типов — метод embedded поля зовёт «своих».

Интерфейсы неявные (duck typing). Правило: **accept interfaces, return structs** — вход гибкий, выход можно расширять без major break. Интерфейс nil, только если **и тип, и значение** nil: `var i I; i = (*T)(nil)` уже не nil. `any` / пустой интерфейс ничего не говорит — избегать. Go не OO и не functional: практичный язык.

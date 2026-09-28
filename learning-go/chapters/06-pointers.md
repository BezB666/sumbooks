# Глава 6. Pointers

- **PDF:** 143–166 (печать 119–142)
- **Якоря:** pointer, last resort, map vs slice, heap, escape analysis, GOGC

Указатель — адрес значения; nil-dereference — panic. **Pointers are a last resort**: не заполнять struct через `*T` параметр, а создать и вернуть значение. Исключение — интерфейс вроде `json.Unmarshal` (и буферы I/O, типы для concurrency). Возвращать указатель — только если состояние надо менять. Для большинства размеров разница value vs pointer ничтожна.

Map в runtime — указатель на struct: правки видны снаружи; в публичном API лучше **struct**, map — если ключи неизвестны на compile time. Slice — length + capacity + указатель на память: копия слайса делит backing array, `append` может уехать на новый. Данные без указателей — garbage; стек быстрее кучи. Escape analysis консервативен. Тюнинг: `GOGC` и `GOMEMLIMIT`.

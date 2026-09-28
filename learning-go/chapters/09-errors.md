# Глава 9. Errors

- **PDF:** 227–246 (печать 203–222)
- **Якоря:** error, sentinel, wrap, errors.Is, errors.As, panic, recover

Ошибка — последнее возвращаемое значение, успех — `nil`; это конвенция, её не ломают. Сообщение без заглавной и без точки. Простые — `errors.New` / `fmt.Errorf`; sentinel — для состояния «дальше нельзя». **Errors are values**: свой тип с `Error()`, но в сигнатуре всё равно `error`. Не возвращать «пустой» custom error — интерфейс будет non-nil (см. гл. 7).

Обёртка: `fmt.Errorf("…: %w", err)`; несколько — `errors.Join`. Для дерева — **`errors.Is` / `errors.As`**, не `==` и не type assert. Panic — почти всегда баг, не исключения; `recover` не заменяет явные ошибки. В публичном API panic не выпускают — переводят в `error`. HTTP-сервер, который сам recover'ит хендлеры, команда Go считает ошибкой.

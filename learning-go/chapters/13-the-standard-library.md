# Глава 13. The Standard Library

- **PDF:** 343–372 (печать 319–348)
- **Якоря:** io.Reader, io.Writer, time, encoding/json, net/http, slog, ResponseController

«Batteries included» под современные задачи. `io.Reader`/`Writer` — одни из самых частых интерфейсов после `error`. `Read` пишет в **переданный** `[]byte`, а не возвращает новый слайс: один буфер, меньше работы GC (как указатели last resort в гл. 6). `time`: monotonic clock для интервалов; `time.Tick` в серьёзном коде не использовать — `NewTicker`.

JSON: marshal/unmarshal, struct tags. `net/http` — клиент и сервер; `ResponseController` (1.20) наращивает API конкретной обёрткой, не ломая интерфейс. **slog** — структурированные логи (текст или JSON). Глава ещё про совместимость: часть решений сегодня сделали бы иначе, но ломать 1.x нельзя.

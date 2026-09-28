# Глава 12. Concurrency in Go

- **PDF:** 311–342 (печать 287–318)
- **Якоря:** goroutine, channel, select, context, WaitGroup, mutex, CSP

Модель — CSP (Hoare), не «потоки + локи» как основной API. **Concurrency ≠ parallelism**; больше горутин ≠ быстрее (Amdahl). Имеет смысл, когда шаги независимы, часто I/O. Горутина — лёгкий поток рантайма; `go f()`. **Keep APIs concurrency-free**: бизнес-логика не знает о каналах, обёртка-closure ведёт bookkeeping.

Каналы, буфер vs без, `select`, закрытие (повторный close/write — panic). Горутину надо **дожать до выхода** (иначе leak); типично — `context` cancel. WaitGroup — когда ждут нескольких и надо один раз `close`. Философия: **«Share memory by communicating; do not communicate by sharing memory.»** Mutex — когда много читают/пишут общее значение и не «обрабатывают» его по пайплайну. Atomics обычно не нужны.

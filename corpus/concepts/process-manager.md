# Process Manager и Routing Slip

## Алиасы

EN: Process Manager, Routing Slip, Saga, orchestration, choreography, Loan Broker  
RU: менеджер процесса, маршрутный лист, сага, оркестрация, хореография

## Упоминания

### EIP гл. 7, 9, 14

- Routing Slip: маршрут известен заранее, едет в сообщении.
- Process Manager: маршрут зависит от ответов, состояние снаружи (Loan Broker гл. 9).
- Гл. 14: BPEL и хореография — те же паттерны на стандартах; Correlation Identifier склеивает уже фрагменты долгого дела.

### GoF

Mediator (консоль гл. 12) — родственник: коллеги не знают друг друга, правила в одном месте. Не путать с Process Manager бизнес-потока.

### Khononov — Learning DDD, гл. 9, PDF 163–184

**Saga** — длинный процесс из нескольких транзакций: слушает события, шлёт команды, компенсирует сбои. **Process Manager** — не линейный match event→command, а ветвящийся workflow со своим состоянием. Оба опираются на async + Outbox. См. [09-communication-patterns.md](../../ddd/chapters/09-communication-patterns.md).

### Newman — Monolith to Microservices, гл. 4, PDF 142–223

Распределённый 2PC — нет. Если атомарность критична и сагу не видно — не режьте эти данные. Иначе Saga: backward (compensating) / forward recovery; orchestration vs choreography. См. [04-decomposing-the-database.md](../../monolith-to-microservices/chapters/04-decomposing-the-database.md).

### Richards/Ford — FSA, гл. 14 и 17

Гл. 14: mediator topology = оркестратор шагов в EDA. Гл. 17: в МС **choreography** чаще из-за perf; saga между сервисами — против причины выбора стиля.

### Ford/Richards — Hard Parts, гл. 11, PDF 505–557

Never say never: хореография не «всегда лучше». Оркестратор — **на workflow**, не глобальный ESB. Сложность/ошибки/state ↑ → оркестрация; scale/responsiveness → хореография. См. [11-managing-distributed-workflows.md](../../hard-parts/chapters/11-managing-distributed-workflows.md). Восемь саг: [transactions.md](transactions.md).

## Сводка

Путь стабильный → slip. Путь живой/долгий → Process Manager. Newman/Khononov/Hard Parts: саги вместо 2PC; оркестрация vs хореография — та же развилка, не догма.

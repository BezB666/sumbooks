# Транзакции, 2PC, саги

## Алиасы

EN: ACID, two-phase commit, 2PC, saga, isolation, serializable, write skew, snapshot isolation, SSI  
RU: транзакция, двухфазный коммит, сага, изоляция, сериализуемость

## Упоминания

### Fowler — PoEAA, гл. 5, PDF 88–105

ACID; business vs system transaction. Длинная бизнес-транзакция ≠ одна системная: optimistic/pessimistic offline lock (гл. 16). Unit of Work (гл. 11) — один commit изменений в памяти.

### Kleppmann — DDIA, гл. 7 и 9

Гл. 7, PDF 243–294: isolation скользкая; write skew закрывает только serializable; пути — serial execution, 2PL, SSI. Распределённые tx — не здесь. См. [07-transactions.md](../../ddia/chapters/07-transactions.md).

Гл. 9, PDF 343–410: 2PC — атомарный commit между участниками, координатор = SPOF; consensus (Raft/ZooKeeper) для membership, не замена бизнес-саге. См. [09-consistency-and-consensus.md](../../ddia/chapters/09-consistency-and-consensus.md).

### Newman — Building Microservices гл. 6; Monolith to Microservices гл. 4

Распределённый 2PC — нет. Саги: компенсирующие шаги, orchestration vs choreography. Если атомарность критична и сагу не видно — не режьте данные.

### Khononov — Learning DDD, гл. 9

Saga и Process Manager поверх Outbox; участники eventually consistent. Не затычка для кривых границ aggregate.

### Ford/Richards — Hard Parts, гл. 9 и 12

Гл. 9, PDF 400–468: кто пишет в таблицу — владелец. Между сервисами **не ACID**, а **BASE** + eventual (Background Sync / Orchestrated Request / Event-Based). См. [09-data-ownership-distributed-transactions.md](../../hard-parts/chapters/09-data-ownership-distributed-transactions.md).

Гл. 12, PDF 558–643: сага = communication × consistency × coordination (8 клеток). Epic/Phone Tag (sync+atomic) дорогие; Horror Story (async+atomic+choreographed) — anti-pattern; Parallel / Anthology — async+eventual. Компенсация без isolation; альтернатива — state machine + retry. См. [12-transactional-sagas.md](../../hard-parts/chapters/12-transactional-sagas.md).

## Сводка

Одна БД → обычная tx + нужный isolation. Несколько сервисов → сага, не 2PC. Kleppmann — *почему* 2PC дорогой; Newman/Khononov — *чем заменить*; Hard Parts — *какой вид саги* и какая цена. Маршрут процесса: [process-manager.md](process-manager.md).

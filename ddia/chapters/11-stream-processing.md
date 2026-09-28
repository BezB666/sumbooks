# Глава 11. Stream Processing

- **PDF:** 461–510 (печать 439–488)
- **Якоря:** message broker, partitioned log, CDC, Event Sourcing, exactly-once, effectively-once, microbatching

Batch режет бесконечные данные на сутки/часы — для многих слишком медленно. Stream: unbounded события (immutable, timestamp). Два брокера.

**AMQP/JMS:** брокер отдаёт сообщение консьюмеру, ack → удалить. Как async RPC / очередь задач; порядок при redelivery+load-balancing плывёт; старьё не перечитать. **Log-based** (Kafka-стиль): партиция → один консьюмер, порядок стабильный, offset как checkpoint, диск хранит историю. Близко к replication log и LSM.

**CDC:** вытащить changelog БД (часто из replication log) и гнать в поиск/кеш/склад в том же порядке — derived systems. Приложение пишет мутабельно, CDC снизу. **Event Sourcing:** приложение само пишет append-only события смысла («студент отчислился»), не низкоуровневые UPDATE/DELETE.

**Exactly-once** в книге = **effectively-once**: в batch повтор таска не виден снаружи. У бесконечного стрима нельзя «показать выход только когда джоба кончилась». Microbatch / checkpoint дают эту семантику *внутри* фреймворка; как только выход ушёл в чужую БД, почту, внешний брокер — retry делает side effect дважды. Нужен атомарный commit всех эффектов или идемпотентная запись.

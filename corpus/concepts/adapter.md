# Adapter, мост, шлюз

## Алиасы

EN: Adapter, Wrapper, Channel Adapter, Messaging Bridge, Messaging Gateway, Anti-Corruption Layer  
RU: адаптер, мост, шлюз, антикоррупционный слой

## Упоминания

### GoF — Adapter

Чужой тип подводят к нужному интерфейсу, не меняя его.

### EIP гл. 4, 10, 13

- Channel Adapter: приложение без messaging-API (файл, JDBC, COM, HTTP) ↔ канал.
- Messaging Bridge: два разных брокера (в гл. 13 TIBCO ↔ MQ через два адаптера + CORBA).
- Messaging Gateway: домен не видит JMS/MSMQ.

### Khononov — Learning DDD, гл. 4, PDF 75–88

**Anticorruption layer** — downstream переводит чужую модель в свою (core, легаси, частые ломающие изменения). **Open-host service** — наоборот: upstream публикует published language, отдельный от внутренней модели. То же семейство, что GoF Adapter, но на границе bounded context. См. [04-integrating-bounded-contexts.md](../../ddd/chapters/04-integrating-bounded-contexts.md).

### Fowler — PoEAA, гл. 18

**Gateway** — неудобный внешний API в одну точку (в т.ч. messaging). **Mapper** — ни одна сторона не зависит от склейки. Рядом с EIP Gateway, не с Channel Adapter.

## Сводка

GoF Adapter — типы. EIP Channel Adapter — вход в шину. Мост — два адаптера спиной. Шлюз прячет брокер от домена. DDD ACL прячет чужую *модель*. Gateway Fowler — чужой *API*.

# Pub/sub и точка-точка

## Алиасы

EN: Publish-Subscribe Channel, Point-to-Point Channel, topic, queue, Observer, Competing Consumers, Message Dispatcher  
RU: подписка, точка-точка, топик, очередь, конкурирующие получатели

## Упоминания

### EIP гл. 4, 10, 13

- Один обработает → Point-to-Point (+ Competing Consumers для масштаба).
- Оповестить всех → Publish-Subscribe.
- Гл. 13 bond desk: сервер→клиент pub/sub, клиент→сервер PTP (трейдер на нескольких машинах). Competing Consumers на топике = все делают одну работу; параллель на Topic → Message Dispatcher.
- GoF Observer ≈ pub/sub канал.

### Richards/Ford — FSA, гл. 14

Broker topology — цепочка pub/sub без центра; competing consumers на процессоре. Mediator — уже оркестрация, не «просто топик».

## Сводка

Канал выбирают по «один vs все», не по технологии брокера. Направление потока может требовать разных типов каналов в одной системе. FSA broker ≈ EIP pub/sub + PTP; mediator ≈ Process Manager.

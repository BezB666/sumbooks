# Observer

## Алиасы

EN: Observer, Publish-Subscribe, event listener, subscriber  
RU: наблюдатель, подписка, слушатель события

## Упоминания

### GoF — Observer

Субъект не знает конкретные типы слушателей; список меняется. Нельзя хардкодить `ui.Refresh(); cache.Drop()`.

### EIP гл. 4, 13

Publish-Subscribe Channel — распределённый Observer: канал избавляет от учёта наблюдателей. Bond desk: цены клиентам через подписку.

## Сводка

В одном процессе — GoF Observer. Между процессами — pub/sub канал. Смысл тот же: публикация без списка получателей в коде отправителя.

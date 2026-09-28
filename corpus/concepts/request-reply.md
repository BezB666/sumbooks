# Request-Reply и корреляция

## Алиасы

EN: Request-Reply, Return Address, Correlation Identifier, reply queue  
RU: запрос-ответ, адрес возврата, корреляция, очередь ответа

## Упоминания

### EIP гл. 5, PDF 140–168

Request-Reply ≈ Return Address (куда класть ответ) + Correlation Identifier (какой это ответ на какой запрос). Это не синхронный стек.

### EIP гл. 6, 11, 12

Код JMS/MSMQ; Smart Proxy перехватывает чужой Return Address, чтобы мерить QoS; без фиксированного reply-канала «подслушать ответ» нельзя.

## Сводка

Путают Return Address (*куда*) и Correlation Identifier (*на какой запрос*). HTTP request/response — другой механизм: корреляция = соединение, не поле в сообщении.

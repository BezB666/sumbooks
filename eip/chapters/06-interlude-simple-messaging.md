# Глава 6. Interlude: Simple Messaging (Интерлюдия: простой обмен сообщениями)

- **PDF:** стр. 169–207
- **Это не новые паттерны.** Код: как кирпичи гл. 3–5 выглядят в JMS и MSMQ.
- **Якоря:** JMS, MSMQ, Request-Reply (запрос-ответ), Publish-Subscribe (публикация-подписка), Correlation Identifier (идентификатор корреляции), Return Address (адрес возврата)

## Два примера

1. Request/Reply (запрос/ответ) — Java JMS и C#/.NET MSMQ
2. Publish/Subscribe (публикация/подписка) — только JMS Topic (у MSMQ тогда нет нормального pub/sub)

## Request/Reply: роли

- Requestor (запрашивающий) шлёт запрос, ждёт ответ
- Replier (ответчик) принимает запрос, шлёт ответ

Какие паттерны видны в маленьком коде:

| Паттерн | Где |
|---|---|
| Point-to-Point Channel (точка-точка) | отдельный request-канал и reply-канал |
| Document Message (документ) | тело запроса и ответа |
| Request-Reply (запрос-ответ) | пара сообщений |
| Return Address (адрес возврата) | куда replier кладёт ответ |
| Correlation Identifier (идентификатор корреляции) | id запроса в ответе |
| Datatype Channel (канал типа данных) | на канале один тип |
| Invalid Message Channel (канал неверных) | не тот тип → спецканал |
| Polling Consumer (опрашивающий потребитель) | requestor читает reply |
| Event-Driven Consumer (событийный потребитель) | replier слушает request |

Смысл двух реализаций: сравнить API, не выучить продукт. JMS: Destination, Producer/Consumer. MSMQ: MessageQueue. Логика одна.

Invalid (неверное): не «бизнес отклонил заявку», а «это вообще не наш message type».

## Publish/Subscribe = Observer (наблюдатель) на Topic

Распределение и треды, которые в in-process Observer боль, здесь забирает брокер.

Push vs pull (толчок vs вытягивание):

- Push: Event Message (событие) с данными сразу
- Pull: нотификация лёгкая, observer запрашивает состояние = Request-Reply (Command туда, Document обратно, Return Address)

Datatype Channel: можно ли двум разным subject кормить одну группу observer одним топиком — только если тип события один.

Из гл. 10 уже мелькают: Messaging Gateway (шлюз; subject/observer не светят JMS), Event-Driven Consumer (событийный потребитель), Durable Subscriber (устойчивый подписчик; не пропустить событие, пока observer был офлайн).

Каналы в большой орг: не один гигантский topic на всё; набор subject по домену, иначе фильтры на каждом клиенте.

## Зачем интерлюдия

После теории каналов и конструирования — минимальный рабочий скелет. Сложный Loan Broker — гл. 9. Management поверх него — гл. 12.

## Связанные паттерны

Message Channel (канал), Point-to-Point Channel (точка-точка), Publish-Subscribe Channel (публикация-подписка), Document Message (документ), Event Message (событие), Command Message (команда), Request-Reply (запрос-ответ), Return Address (адрес возврата), Correlation Identifier (корреляция), Datatype Channel (канал типа данных), Invalid Message Channel (канал неверных), Polling Consumer (опрашивающий), Event-Driven Consumer (событийный), Messaging Gateway (шлюз), Durable Subscriber (устойчивый подписчик)

# EIP — INDEX

Конспекты по [Enterprise Integration Patterns](../books/EIP%20Enterprise%20Integration%20Patterns.pdf) (PDF, 574 стр.). Текст книги не копировали. Имена паттернов — английские.

**Как пользоваться:** открытый вопрос → `py tools/search.py "…"` и [corpus/INDEX.md](../corpus/INDEX.md). Узкий вопрос по EIP → Grep по этому файлу или `chapters/`.

## Оглавление

| # | Файл | PDF | Что это |
|---|---|---|---|
| — | [00-introduction](chapters/00-introduction.md) | 12–29 | зачем messaging, не RPC |
| 1 | [01-solving-integration-problems-using-patterns](chapters/01-solving-integration-problems-using-patterns.md) | 31–61 | зачем интеграция, Widget-Gadget |
| 2 | [02-integration-styles](chapters/02-integration-styles.md) | 63–74 | File / DB / RPC / Messaging |
| 3 | [03-messaging-systems](chapters/03-messaging-systems.md) | 75–107 | 6 кирпичей |
| 4 | [04-messaging-channels](chapters/04-messaging-channels.md) | 108–139 | типы каналов, мост, шина |
| 5 | [05-message-construction](chapters/05-message-construction.md) | 140–168 | команда / документ / событие, request-reply |
| 6 | [06-interlude-simple-messaging](chapters/06-interlude-simple-messaging.md) | 169–207 | код JMS + MSMQ |
| 7 | [07-message-routing](chapters/07-message-routing.md) | 208–290 | куда едет сообщение |
| 8 | [08-message-transformation](chapters/08-message-transformation.md) | 291–316 | форматы, каноника |
| 9 | [09-interlude-composed-messaging](chapters/09-interlude-composed-messaging.md) | 317–414 | Loan Broker × 3 |
| 10 | [10-messaging-endpoints](chapters/10-messaging-endpoints.md) | 415–475 | как приложение садится на брокер |
| 11 | [11-system-management](chapters/11-system-management.md) | 476–503 | прод, отладка |
| 12 | [12-interlude-system-management-example](chapters/12-interlude-system-management-example.md) | 503–527 | Loan Broker + QoS/failover |
| 13 | [13-integration-patterns-in-practice](chapters/13-integration-patterns-in-practice.md) | 528–547 | bond desk |
| 14 | [14-concluding-remarks](chapters/14-concluding-remarks.md) | 548–568 | BPEL / WS-* как те же паттерны |

Библиография PDF 569–574 — не конспектировали.

Интерлюдии 6, 9, 12 — склейка, не новые паттерны.

---

## Стили интеграции (гл. 2)

| Когда | Стиль |
|---|---|
| Batch, файлы уже есть, реалтайм не нужен | File Transfer |
| Одна модель, один DBA, все пишут в одни таблицы | Shared Database |
| Нужен ответ сейчас, обе стороны живы | Remote Procedure Invocation |
| Пики, недоступность, pub/sub, разные платформы | Messaging |

---

## Каталог паттернов

### Messaging Systems — гл. 3

| Паттерн | Когда |
|---|---|
| Message Channel | договор «куда класть», без знания кто на том конце |
| Message | единица передачи: header + body |
| Pipes and Filters | шаги обработки независимы, можно вставлять/убирать |
| Message Router | источник не должен знать конечный канал |
| Message Translator | системы не согласны о формате |
| Message Endpoint | код у границы приложения и брокера |

### Channels — гл. 4

| Паттерн | Когда |
|---|---|
| Point-to-Point Channel | ровно один обработает (задача, команда) |
| Publish-Subscribe Channel | все подписчики получают копию (событие) |
| Datatype Channel | на канале один тип, иначе каждый пишет свой парсер |
| Invalid Message Channel | дошло, но это не наш контракт |
| Dead Letter Channel | брокер не смог доставить (TTL, нет маршрута) |
| Guaranteed Delivery | потеря дороже диска; не для протухающих котировок |
| Channel Adapter | приложение без messaging-API |
| Messaging Bridge | два разных брокера |
| Message Bus | общая шина + каноника, новые системы без паутины связей |

### Construction — гл. 5

| Паттерн | Когда |
|---|---|
| Command Message | «сделай действие», побочный эффект |
| Document Message | «вот данные, решай сам» |
| Event Message | «случилось» |
| Request-Reply | нужен ответ, но это не синхронный стек |
| Return Address | куда класть ответ (клиент задаёт канал) |
| Correlation Identifier | какой это ответ на какой запрос |
| Message Sequence | одно логическое не влезло / список фрагментов |
| Message Expiration | после TTL обрабатывать нельзя |
| Format Indicator | версия контракта в header |

Request-Reply почти всегда = Return Address + Correlation Identifier.

### Routing — гл. 7

| Паттерн | Когда |
|---|---|
| Content-Based Router | один вход → один из каналов по содержимому |
| Message Filter | пропустить или выкинуть |
| Dynamic Router | правила меняются с control-порта |
| Recipient List | явно список получателей, контроль у отправителя |
| Splitter | список в теле → по сообщению на элемент |
| Aggregator | много родственных → одно (stateful) |
| Resequencer | вернуть порядок, столько же на выходе |
| Composed Message Processor | Splitter → обработка → Aggregator |
| Scatter-Gather | спросить многих, склеить ответы |
| Routing Slip | маршрут известен заранее, едет в сообщении |
| Process Manager | маршрут зависит от ответов, долгое состояние |
| Message Broker | центральный хаб правил (архитектура, не Loan Broker) |

### Transformation — гл. 8

| Паттерн | Когда |
|---|---|
| Envelope Wrapper | брокеру/протоколу нужен свой конверт |
| Content Enricher | целевой системе не хватает полей |
| Content Filter | лишнее нельзя тащить дальше |
| Claim Check | большой/секретный кусок не в канал, а в стор + бирка |
| Normalizer | N входящих форматов → один операционный |
| Canonical Data Model | язык всей шины, маппинг только в канонику и обратно |

### Endpoints — гл. 10

| Паттерн | Когда |
|---|---|
| Messaging Gateway | домен не должен видеть JMS/MSMQ |
| Messaging Mapper | объекты приложения ≠ тело сообщения |
| Transactional Client | сообщение и БД в одной внешней транзакции |
| Polling Consumer | приложение само задаёт темп |
| Event-Driven Consumer | callback от брокера |
| Competing Consumers | масштаб/failover на Point-to-Point |
| Message Dispatcher | пул воркеров; работает и на Topic |
| Selective Consumer | фильтр в API брокера, не отдельный компонент |
| Durable Subscriber | pub/sub, не терять события в офлайне |
| Idempotent Receiver | at-least-once, дубликаты не ломают смысл |
| Service Activator | сообщение → вызов сервиса |

### System Management — гл. 11

| Паттерн | Когда |
|---|---|
| Control Bus | команды и метрики отдельно от бизнеса |
| Detour | временно вставить валидацию/лог |
| Wire Tap | копия потока, основной не трогать |
| Message History | кто трогал это сообщение |
| Message Store | архив всех сообщений |
| Smart Proxy | поймать request+reply при чужом Return Address |
| Test Message | проверить живой сервис синтетикой |
| Channel Purger | вычистить застрявшее |

---

## Когда что: развилки

### Канал

1. Обработать **один раз** → Point-to-Point (+ Competing Consumers, если надо масштаб)
2. Оповестить **всех** → Publish-Subscribe
3. Трейдер на двух машинах (гл. 13) → сервер→клиент pub/sub, клиент→сервер PTP

### Маршрут

1. Один из N по полям, список назначений стабильный → Content-Based Router
2. Получатели сами решают → pub/sub + Message Filter / Selective Consumer
3. Отправитель держит список → Recipient List
4. Спросить многих и склеить → Scatter-Gather
5. Путь известен заранее → Routing Slip; путь живой/долгий → Process Manager

### Формат

1. Две системы, разовый стык → Message Translator
2. Много входов в один агрегат → Normalizer
3. Вся шина → Canonical Data Model + адаптеры
4. Поля нет у источника → Content Enricher
5. Payload слишком большой/секретный → Claim Check

### Приём

1. Нужен ручной темп → Polling Consumer
2. Нужна реакция сразу, нагрузка предсказуема → Event-Driven Consumer
3. PTP + параллель → Competing Consumers
4. Pub/sub + параллель → Message Dispatcher (не competing)
5. Доставка повторяется → Idempotent Receiver

### Прод

1. Не видно request-reply → Smart Proxy
2. Посмотреть тело, не тормозя поток → Wire Tap
3. Внешний сервис молчит → Test Message
4. Канал забит ядом/тестами → Channel Purger
5. Правила failover в одном месте → Control Bus + Mediator (гл. 12)

---

## Частые путаницы

| Путают | Разница |
|---|---|
| Invalid Message vs Dead Letter | приложение не поняло контракт vs брокер не доставил |
| Message Filter vs Selective Consumer | компонент потока vs фильтр в endpoint |
| Return Address vs Correlation Identifier | *куда* ответить vs *на какой запрос* |
| Splitter vs Message Sequence | бизнес-список на много сообщений vs фрагменты одного |
| Normalizer vs Canonical Data Model | операционный свод vs стратегия шины |
| Message Broker vs Message Bus vs Loan Broker | хаб маршрутов vs стиль подключения vs бизнес-посредник гл. 9 |
| Competing Consumers vs Message Dispatcher | только PTP, каждый своё vs пул, в т.ч. на Topic |
| Routing Slip vs Process Manager | маршрут в сообщении vs состояние снаружи |

---

## Сквозные примеры

| Пример | Глава | Зачем читать |
|---|---|---|
| JMS / MSMQ request-reply, JMS pub/sub | [6](chapters/06-interlude-simple-messaging.md) | минимальный код |
| Loan Broker (WS / MSMQ / TIBCO) | [9](chapters/09-interlude-composed-messaging.md) | Scatter-Gather + Enricher + Process Manager |
| Loan Broker + консоль | [12](chapters/12-interlude-system-management-example.md) | Smart Proxy, Test Message, failover |
| Bond trading desk | [13](chapters/13-integration-patterns-in-practice.md) | мост TIB↔JMS, каналы, прод-падение |
| BPEL / ebMS / WS-* | [14](chapters/14-concluding-remarks.md) | те же паттерны на стандартах 2000-х |

---

## Чего в репо нет

- `eip/patterns/` — по файлу на паттерн
- `eip/maps/` — отдельные деревья
- полный текст книги в git (extract/ и sqlite локально)

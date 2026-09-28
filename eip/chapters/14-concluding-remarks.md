# Глава 14. Concluding Remarks (Заключительные замечания)

- **PDF:** стр. 548–568
- **Автор:** Sean Neville
- **Подзаголовок:** Emerging Standards and Futures in Enterprise Integration (Новые стандарты и будущее корпоративной интеграции)
- **Это не новые EIP-паттерны.** Как стандарты середины 2000-х поднимают те же паттерны с кода на процессы. Библиография (стр. 569–574) — отдельный список, саммари не нужна.
- **Якоря:** BPEL, SOAP, WS-*, ebMS, Process Manager (менеджер процесса), Idempotent Receiver (идемпотентный получатель), Correlation Identifier (идентификатор корреляции), Message Broker (брокер сообщений)

## Тезис

Паттерн почти не меняется. Меняется тактика: EDI → MOM → XML/SOAP → BPEL. Стандарты не убивают паттерн — делают реализации совместимыми, и тот же Message Router (маршрутизатор) начинает маршрутировать workflow (поток работ), а не куски XML.

Без стандарта Java-разработчик пишет Message Router руками по XML. Со стандартом choreography (хореография) — тот же паттерн на уровне процессных компонентов. Correlation Identifier — не «этот reply к тому request», а «этот кусок процесса к тому».

## Стандарты и паттерны

Две верхние абстракции: ориентации (ООП, SOA, generative / порождающие) и языки паттернов. Если контекст повторяется, тактики сходятся. Мелочи семантики ломают интероп. Стандарт вычищает мелочи.

Pipes and Filters (трубы и фильтры) живёт сразу на нескольких этажах: приложение, сервер, контейнер, messaging-подсистема.

## Кто пишет стандарты

| Кто | Роль |
|---|---|
| W3C | SOAP, WSDL, XML; Choreography WG должен был склеить процессные спеки |
| OASIS | ebXML, WS-Reliability; xml.org |
| WS-I | Basic Profile: какие версии XML Schema/SOAP/WSDL/UDDI вместе |
| JCP | Java-биндинги; IP часто у Sun |
| Ad hoc (IBM+MS и др.) | WS-* без комитета; BPEL потом ушёл в OASIS |

## Business process component (компонент бизнес-процесса)

Не «объект или процесс», а объект, чьё главное — как он общается. Набор веб-сервисов + правила потока сообщений = один компонент с одним endpoint (конечной точкой). Клиенту не нужен свой Process Manager.

Пример из главы: Process Purchase Order — несколько операций параллельно, зависимости (shipping/insurance → цена; страховка → производство), снаружи одна точка входа, дальше линк на Process Invoice.

Четыре линейки: ebXML/ebMS, BPEL4WS, WSCI, WS-*.

## ebXML / ebMS

Наследник EDI (UN/CEFACT + OASIS). Payload (нагрузка) любой: XML, EDI, бинарь. SOAP + attachments. SOAP Header: id, timestamp, подпись, манифест → Message Routing (маршрутизация), Idempotent Receiver (идемпотентный получатель), гарантированный порядок.

Надёжность: persist на отправителе, once-and-only-once (ровно один раз), store-and-forward (сохранить-и-переслать). Message Status Service = Control Bus (шина управления) поверх Message History (истории сообщения). Мост между чужими MOM и экстранетом/B2B.

## BPEL4WS («bee-pel»)

Склейка IBM WSFL + Microsoft XLANG (BizTalk). OASIS. Декларативный Process Manager: partners, containers (≈ Datatype Channel / канал типа данных / общий стор с семантикой), activities. Импорт WSDL, `serviceLinkType`, `<invoke>` / `<receive>` / `<reply>`, `<flow>` / `<pick>`, XPath. Сам процесс тоже торчит WSDL, но portType — вход/выход процесса, не методы сервиса. Движок читает XML и поднимает шину.

## WSCI («whiskey»)

Тот же домен, другой альянс (Sun, Intalio, SAP, BEA), в W3C. Потом часть авторов ушла к BPEL. Синтаксис внутри WSDL. Action → операция WSDL; process: последовательность / параллель / цикл / условие. Децентрализованная координация, динамический discovery (обнаружение).

## Java: JSR-207 и JSR-208

Не дубли, слои:

- **JSR-207 Process Definition for Java (BEA):** метаданные на Java-коде → асинхронность, корреляция, маршруты. Сейчас в J2EE это можно, но низко и дорого сопровождать.
- **JSR-208 Java Business Integration / JBI (Sun):** SPI для вендоров, не API приложений. Bindings / machines / environment. Упаковка сверх WAR/EAR. Машина JSR-207 должна через JBI отдать Message Translator (транслятор), Service Activator (активатор сервиса), Envelope Wrapper (обёртка-конверт).

## WS-* (узкие SOAP-надстройки)

Ландшафт грязный, конкурирующие версии, в проде тогда мало. Имеет смысл брать идиомы, не ждать зрелости всего пакета. Если стандарт мешает — игнорировать, пока не созреет.

| Спека | Зачем | Паттерны рядом |
|---|---|---|
| WS-Coordination / WS-Transaction | Контекст в SOAP Header, атомарные TX (как XA/2PC) vs Business Activity (долгий поток, компенсация, не глобальный rollback) | Content Filter (фильтр содержимого), Splitter (разделитель) |
| WS-Reliability (OASIS, от ebMS) | ack/fault, persist, group+sequence | Guaranteed Delivery (гарантированная доставка), Resequencer (восстановитель порядка) |
| WS-ReliableMessaging (BEA/IBM/MS) | at most/at least/exactly once (не больше / не меньше / ровно один раз), in order; плюс WS-Security/Addressing | то же |
| WS-Conversation | stateful диалог двух endpoint, token в Header | Aggregator (агрегатор), Composed Message Processor (составной обработчик), Correlation Identifier |
| WS-Security | токены/подписи в SOAP, XML Signature/Encryption; HTTPS если нет посредников | идентичность отправителя, целостность |
| WS-Addressing | From/To, куда reply | Recipient List (список получателей), Return Address (адрес возврата) |
| WS-Policy* | требования/QoS сервиса, привязка к WSDL/UDDI | метаданные endpoint |

## Вывод главы

Стандарты растягивают паттерн на интероп. BPEL/WSCI/WS-* закрывают задачи этой книги. Спеки конфликтуют и сырые. При применении паттерна смотреть use case, брать идиому если помогает, не тонуть в комитетах. Паттерн важнее вендорского XML.

## Связанные паттерны

Process Manager (менеджер процесса), Pipes and Filters (трубы и фильтры), Message Router (маршрутизатор), Correlation Identifier (корреляция), Datatype Channel (канал типа данных), Durable Subscriber (устойчивый подписчик), Routing Slip (маршрутный лист), Message Translator (транслятор), Idempotent Receiver (идемпотентный), Guaranteed Delivery (гарантированная доставка), Resequencer (восстановитель порядка), Control Bus (шина управления), Message History (история), Content Filter (фильтр содержимого), Splitter (разделитель), Aggregator (агрегатор), Composed Message Processor (составной обработчик), Recipient List (список получателей), Return Address (адрес возврата), Service Activator (активатор сервиса), Envelope Wrapper (обёртка-конверт)

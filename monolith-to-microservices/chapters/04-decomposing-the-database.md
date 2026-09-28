# Глава 4. Decomposing the Database

- **PDF:** 142–223 (печать 125–206)
- **Якоря:** shared database, Database View, wrapping service, Tracer Write, Split Table, foreign key, two-phase commit, Saga

МС прячут своё хранилище. Shared database — implementation coupling. Смягчения: **Database View**; **Database Wrapping Service** (тонкий API над кашей); **Database-as-a-Service Interface** (отдельная read-only БД как контракт, aka reporting database). Перенос владения: Aggregate Exposing Monolith; **Tracer Write** — два source of truth, писать в оба, потом выключить старый. Сначала логическое разделение схемы; физический движок можно общий. Резать БД первой, код первым или вместе: схема первой ловит join и транзакции раньше, но мало быстрой выгоды.

Таблицы: **Split Table** по bounded context; **Move Foreign-Key Relationship to Code** — join в приложении, целостность уже не БД. Транзакции: ACID на одну БД; распределённый **2PC — нет**. Если атомарность критична и сагу не видно — не режьте эти данные. Иначе **Saga**: шаги без долгих локов, backward (compensating) / forward recovery; orchestration vs choreography.

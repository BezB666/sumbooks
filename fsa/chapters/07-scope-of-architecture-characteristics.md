# Глава 7. Scope of Architecture Characteristics (Область действия характеристик архитектуры)

- **PDF:** 132–143 (печать 120–131)
- **Якоря:** architecture quantum (квант архитектуры), independently deployable (независимо развёртываемый), functional cohesion (функциональная связность), synchronous connascence (синхронная коннасценция), bounded context (ограниченный контекст)

Ilities (характеристики на «-ость») больше не «на всю систему»: у монолита так и было, у МС scope (область действия) сузился. Код-метрики не видят БД и прочие зависимости.

**Architecture quantum** (квант архитектуры): independently deployable artifact (независимо развёртываемый артефакт) с **high functional cohesion** (высокой функциональной связностью) и **synchronous connascence** (синхронной коннасценцией). Квант включает всё, без чего не работает (часто БД). Одна shared DB (общая БД) → квант = 1; МС со своей БД на сервис → много квантов. Sync-вызов (синхронный) связывает operational characteristics (операционные характеристики) вызывающего и вызываемого. Связь с DDD **bounded context** (ограниченный контекст). Кейс Going, Going, Gone.

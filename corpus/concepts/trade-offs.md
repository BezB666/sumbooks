# Trade-off analysis и зерно сервиса

## Алиасы

EN: trade-off, least worst, no best practices, integrator, disintegrator, service granularity, entangled dimensions  
RU: компромисс, зерно сервиса, нет лучших практик

## Упоминания

### Richards/Ford — FSA, гл. 1–2, 18

First Law: everything is a trade-off; если минуса не видно — ещё не нашли. Архитектор мыслит вариантами, не «правильным» стеком. Гл. 18: выбрать стиль нельзя заранее.

### Ford/Richards — Hard Parts

Гл. 1: нет Stack Overflow и silver bullet; цель — **least worst**. Гл. 15: распутать измерения (static coupling diagram) → зафиксировать ось (часто sync/async) → крутить остальные; сравнения **качественные**, списки **MECE**; не тащить чужой контекст. См. [15-build-your-own-trade-off-analysis.md](../../hard-parts/chapters/15-build-your-own-trade-off-analysis.md).

Гл. 7, PDF 318–347: modularity = резать систему; **granularity** = размер куска. **Disintegrators** (мельчить): volatility, scale, FT, security, слабая связность. **Integrators** (клеить): ACID между сервисами, workflow, shared code, data relationships. См. [07-service-granularity.md](../../hard-parts/chapters/07-service-granularity.md).

Гл. 8: reuse ценен при медленном rate of change; доменный код — плохая цель сцепления (sidecar / library / shared service).

## Сводка

FSA даёт закон и стили. Hard Parts — процедуру: изолировать измерения и назвать цену. Зерно сервиса — равновесие integrator/disintegrator, не «чем мельче, тем лучше». Квант: [architecture-quantum.md](architecture-quantum.md).

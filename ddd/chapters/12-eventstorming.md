# Глава 12. EventStorming

- **PDF:** 211–226 (печать 185–200)
- **Якоря:** EventStorming, Brandolini, domain event, pivotal event, aggregate, bounded context

Низкотех воркшоп Brandolini: процесс как лента **domain events** (прошедшее время) на стене. 2–4 часа, разношёрстная группа ≤10, без стульев. Цель — знание и UL, не «красивая диаграмма».

Десять шагов: (1) хаотичные оранжевые события; (2) таймлайн, happy path потом ветки; (3) pain points (розовые ромбы); (4) **pivotal events** — смена фазы, кандидаты в границы BC; (5) commands (голубые) + actors; (6) policies (фиолетовые): event автоматически жжёт command; (7) read models (зелёные); (8) external systems (розовые); (9) aggregates (жёлтые: command слева, event справа); (10) группы aggregate → BC. Вариант: сначала big picture (шаги 1–4), потом полный проход по процессу. Не для тривиального линейного CRUD. Remote — меньше людей, miro; живьём лучше.

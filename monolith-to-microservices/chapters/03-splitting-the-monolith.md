# Глава 3. Splitting the Monolith

- **PDF:** 92–141 (печать 75–124)
- **Якоря:** Strangler Fig, UI composition, Branch by Abstraction, Parallel Run, Decorating Collaborator, Change Data Capture

Инкрементально, с живым монолитом. Если код можно менять — больше паттернов; если нет (вендор, потерянный исходник) — перехват снаружи. Функциональность сначала **копируют**, не вырезают: rollback и Parallel Run. Deploy ≠ release. Пока режете кусок — лучше не менять его поведение.

**Strangler Fig** (Fowler) — перехват на периметре (HTTP proxy, FTP, сообщения), старое и новое сосуществуют, шаг обратимый. **UI composition** — страницы, виджеты, Micro Frontends. **Branch by Abstraction** — функциональность внутри монолита; не long-lived git branch. **Parallel Run** — зовут оба, source of truth пока старый (это не canary: canary делит пользователей). **Decorating Collaborator** — после ответа монолита дернуть новый сервис, монолит не трогая. **Change Data Capture** — реакция на запись в БД (триггеры, transaction log, batch delta), когда периметр и код недоступны.

# Глава 10. Design Heuristics

- **PDF:** 185–194 (печать 159–168)
- **Якоря:** heuristic, decision tree, testing pyramid, testing diamond

Heuristic — правило большого пальца, не теорема. Размер BC не цель: размер следует из модели. Для незнакомого/летучего **core** начинать с широких BC (несколько subdomain); узкие физические границы дорого чинить. Supporting/generic стабильнее — можно уже.

Дерево логики: деньги / обязательный audit / глубокая аналитика поведения → **event-sourced domain model**; сложные правила → **Domain Model**; сложные структуры, простая логика → **Active Record**; иначе **Transaction Script**. Если «core», а выбран TS/AR (или наоборот) — пересмотреть тип subdomain. Архитектура: ES → CQRS; DM → Ports & Adapters; AR → layered + application layer; TS → простой layered. Тесты: pyramid (DM/ES), diamond (AR), reversed pyramid (TS). Дерево — старт, не замена мышления; кто годами живёт на ES, может упрощать иначе.

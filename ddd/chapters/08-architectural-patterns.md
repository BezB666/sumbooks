# Глава 8. Architectural Patterns

- **PDF:** 143–162 (печать 117–136)
- **Якоря:** layered architecture, Ports & Adapters, hexagonal, CQRS, polyglot persistence

Архитектура держит логику отдельно от UI/БД, иначе правила расползаются. Три паттерна.

**Layered:** presentation (GUI/CLI/API/брокер) → business logic → data access. Слой зависит сверху вниз. Хорошо для Transaction Script / Active Record; Domain Model втискивается плохо (сущности не должны знать инфраструктуру). Layer ≠ tier: слой логический, один деплой.

**Ports & Adapters** (hexagonal / onion / clean): DIP, логика в центре, инфраструктура снаружи через порты. Application layer — фасад use case. Место Domain Model.

**CQRS:** одна command-модель (строго согласованная запись) и отдельные read-модели, в т.ч. в разных БД (polyglot). Обязателен для event-sourced; полезен и без ES, если нужны несколько persistent-моделей. Команда может и должна возвращать данные из command-модели; «command never returns» — заблуждение. Проекции eventually consistent.

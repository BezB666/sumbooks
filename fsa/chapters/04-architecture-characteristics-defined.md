# Глава 4. Architecture Characteristics Defined (Определение характеристик архитектуры)

- **PDF:** 83–97 (печать 71–85)
- **Якоря:** architecture characteristics (характеристики архитектуры), operational (операционные), structural (структурные), cross-cutting (сквозные), least worst architecture (наименее плохая архитектура)

Characteristic (характеристика): не домен, а *как* система должна работать; влияет на структуру; критична для успеха. Слишком много ilities (характеристик на «-ость») = лишняя сложность. Списки неполные, организации путают термины (ubiquitous language / единый язык).

Три корзины: **operational** (операционные; availability / доступность, performance / производительность, scalability / масштабируемость, elasticity / эластичность, reliability / надёжность… — пересечение с ops / эксплуатацией); **structural** (структурные; modularity / модульность, extensibility / расширяемость, maintainability / сопровождаемость, portability / переносимость…); **cross-cutting** (сквозные; security / безопасность, legal/GDPR / правовое/GDPR, usability / удобство использования, accessibility / доступность…). Implicit vs explicit (неявные vs явные) — подробно в гл. 5.

Trade-off (компромисс): ilities (характеристики на «-ость») бьют друг друга (security / безопасность режет performance / производительность). Цель — **least worst architecture** (наименее плохая архитектура), не идеал.

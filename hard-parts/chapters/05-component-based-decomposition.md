# Глава 5. Component-Based Decomposition Patterns (Паттерны компонентной декомпозиции)

- **PDF:** 124–231 (печать 112–219)
- **Якоря:** Identify and Size Components (выявить и оценить размер), Gather Common Domain Components (собрать общие доменные), Flatten Components (выровнять), Determine Component Dependencies (зависимости), Create Component Domains (домены компонент), Create Domain Services (доменные сервисы), architecture story (архитектурная история)

Addison и Austen выбрали component-based путь, в интернете почти ничего нет. Logan: паттерны итеративные, цель — безопасно дойти до service-based / микросервисов; «второго раза не будет». Порядок важен: сначала понять и починить компоненты *внутри* монолита, потом группировать, и только потом выносить в отдельные деплои.

**Architecture story** (архитектурная история) ≠ user story и ≠ tech debt: это структурный рефакторинг под характеристику («сделать компоненты листам namespace», «вынести домен X»). На каждый шаг — **fitness function** (фитнес-функция), обычно в CI/CD: oversized-компонент, дубли доменных классов между namespace, слишком много `.sharedcode`.

Шесть паттернов подряд:

| Pattern | Что происходит / цена |
|---|---|
| Identify and Size Components (выявить и оценить) | Инвентаризация: компонент ≈ сумма statements. Цель — куски около среднего (1–2 σ). Oversized хуже резать; порог % от кодовой базы зависит от числа компонент |
| Gather Common Domain Components (собрать общие доменные) | Схлопнуть дубли *доменной* логики (не logging/metrics). Иначе при нарезке размножатся почти одинаковые сервисы и shared libraries |
| Flatten Components (выровнять) | Компонент = лист namespace. Код «посередине дерева» — subdomain без идентичности; его нельзя честно вынести |
| Determine Component Dependencies (зависимости) | Смотрят зависимости *компонент*, не классов. Feasibility (осуществимость): golfball / basketball / airliner — насколько запутан граф. Если sharedcode = огромная доля — distributed станет кошмаром библиотек |
| Create Component Domains (домены компонент) | Группировка 1 будущий сервис : N компонент. Namespace вида `domain.subdomain.component` |
| Create Domain Services (доменные сервисы) | Вынести домены в отдельно деплоимые **domain services** → service-based: UI + coarse services (крупнозернистые сервисы) + часто ещё одна БД |

После этого система уже не один монолитный процесс, но данные ещё общие. Гранулярность «резать ли Ticketing на четыре сервиса» — гл. 7. Данные — гл. 6.

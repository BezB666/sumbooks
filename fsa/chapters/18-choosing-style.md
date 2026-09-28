# Глава 18. Choosing the Appropriate Architecture Style (Выбор подходящего стиля архитектуры)

- **PDF:** 348–363 (печать 336–351)
- **Якоря:** it depends (зависит), domain/architecture isomorphism (изоморфизм домена и архитектуры), monolith versus distributed (монолит против распределённого), Silicon Sandwiches, Going Going Gone

«It depends» (зависит): стиль — итог trade-offs (компромиссов; domain / домен, ilities / характеристики на «-ость», data / данные, оргфакторы, зрелость процесса/ops / эксплуатации). Мода стилей сдвигается: боль прошлого, экосистема, лицензии. Критерии: понять домен; ilities, которые меняют структуру; data architecture (архитектура данных); команды и ops; **domain/architecture isomorphism** (изоморфизм домена и архитектуры; Microkernel ↔ кастомизация; Space-Based ↔ дискретная параллельность; сильная semantic coupling / семантическое сцепление плохо ложится на МС).

Развилка: один набор ilities → монолит (в т.ч. modular monolith / модульный монолит); разные кванты → distributed (распределённый). Потом: где живут данные, sync vs async (синхронно vs асинхронно). Кейсы: Silicon Sandwiches (монолит/плагины) и Going, Going, Gone (разные характеристики кусков → distributed).

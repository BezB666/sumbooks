# Глава 3. Modularity (Модульность)

- **PDF:** 59–82 (печать 47–70)
- **Якоря:** modularity (модульность), coupling (сцепление), cohesion (связность), LCOM, afferent (афферентное), efferent (эфферентное), abstractness (абстрактность), instability (неустойчивость), distance from the main sequence (расстояние до главной последовательности), connascence (со-рождение / коннасценция)

Модульность — organising principle (организующий принцип) и implicit characteristic (неявная характеристика): без неё система идёт в энтропию. Метрики: cohesion (связность; LCOM), **afferent/efferent** (афферентное/эфферентное) coupling (сцепление; Yourdon/Constantine), затем **abstractness** (абстрактность), **instability** (неустойчивость), **distance from the main sequence** (расстояние до главной последовательности).

**Connascence** (коннасценция / со-рождение; Page-Jones): два компонента connascent (со-рождённые), если изменение одного требует правки другого. Статические: Name (имя), Type (тип), Position (позиция), Algorithm (алгоритм). Динамические: Execution (исполнение), Timing (время), Values (значения), Identity (идентичность). Правила: сильные формы → слабые; чем дальше элементы, тем слабее связь. Coupling (сцепление) и connascence (коннасценция) — разные эпохи, для архитектора пересекаются. Дальше модули становятся components (компонентами).

# Глава 8. Generics

- **PDF:** 205–226 (печать 181–202)
- **Якоря:** type parameter, constraint, comparable, any, type term

До 1.18 пользовательские функции/типы не принимали разные конкретные типы; встроенные (`len`, slice, map) — да. Type parameters убирают копипасту и дают проверку на компиляции. `any` не сравнивается через `==`; для этого constraint **`comparable`**. Type terms ограничивают операторы (числа). Нет parameterized methods, нет variadic type parameters.

Идиомы сдвигаются: `float64` «на все числа» уходит; вместо `interface{}` — `any`; один код на разные слайсы. Старый код не обязательно сразу переписывать. **Не** менять параметр-интерфейс на generic ради скорости: в 1.20 простой вызов мог стать ~на 30% медленнее (одна функция на underlying type, lookup в runtime).

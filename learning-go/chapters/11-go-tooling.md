# Глава 11. Go Tooling

- **PDF:** 287–310 (печать 263–286)
- **Якоря:** go run, go install, goimports, staticcheck, golangci-lint, govulncheck, embed, go generate, build tags

Язык — не только синтаксис: сборка, формат, проверка, раздача. `go run` — быстрый цикл как у скрипта. Сторонние команды — `go install …@latest`. `goimports` чинит импорты. Сканеры качества: **staticcheck**, revive, «буфет» **golangci-lint** (ловит ineffectual assignment, который `vet` пропускает). **govulncheck** — уязвимости в зависимостях.

`//go:embed` кладёт файлы в бинарник. `go generate` + stringer и т.п.; часто вместе с Makefile. Build info внутри бинарника; кросс-компиляция `GOOS`/`GOARCH`; **build tags**. Вторичный toolchain (`go1.x.y`) для проверки версии. Справка: `go help`.

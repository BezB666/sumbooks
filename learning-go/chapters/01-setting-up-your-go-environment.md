# Глава 1. Setting Up Your Go Environment

- **PDF:** 25–40 (печать 1–16)
- **Якоря:** go install, go.mod, go build, go fmt, go vet, Makefile, Compatibility Promise

Go ставится с сайта / Homebrew / Chocolatey; проверка — `go version`. Программа собирается в **один нативный бинарник**, без VM на машине пользователя. GOROOT/GOPATH можно игнорировать: проект кладут куда угодно, `go mod init` делает модуль. `go.mod` руками не правят — `go get` и `go mod tidy`. `go build`, `go fmt ./...` (единый стиль, табы, `{` на той же строке из-за semicolon insertion), `go vet`. VS Code, GoLand, Playground.

Для повторяемой сборки — Makefile: сначала `fmt`, потом `vet`, потом `build`. Compatibility Promise: язык и стандартная библиотека 1.x не ломают код; флаги `go` — могут. Обновление toolchain не трогает уже собранные бинарники.

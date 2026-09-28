# Глава 15. Writing Tests

- **PDF:** 395–432 (печать 371–408)
- **Якоря:** go test, testing.T, table test, coverage, fuzz, benchmark, httptest, race detector

Тесты лежат рядом с кодом: `foo_test.go`, пакет тот же (видят unexported). Функция `TestXxx(t *testing.T)`, без возврата; провал — `t.Error` / `Fatal`. Запуск: `go test`. Table tests — много кейсов без копипасты setup. **Coverage необходим, но не достаточен**: 100% не значит нет бага.

Дальше: fuzz (случайный ввод сверх того, что придумал автор), benchmarks, stubs, `httptest`, integration через build tags. Data race detector (`-race`) ловит гонки; бинарь ~в 10 раз медленнее, поэтому не всегда включают.

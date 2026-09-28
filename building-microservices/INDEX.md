# Building Microservices — INDEX

Конспекты по [Building Microservices, 2nd ed.](../books/building-microservices-designing-fine-grained-systems-2-ed.pdf) (Newman, O’Reilly). PDF 615 стр.; печатная страница = PDF − 26. Текст книги в git не копировали.

**Как пользоваться:** `py tools/search.py "…" --book building-microservices` и [corpus/INDEX.md](../corpus/INDEX.md).

## Оглавление

| # | Файл | PDF | Печать | Что это |
|---|---|---|---|---|
| 1 | [01-what-are-microservices](chapters/01-what-are-microservices.md) | 29–60 | 3–34 | что такое МС, монолит, за и против |
| 2 | [02-how-to-model-microservices](chapters/02-how-to-model-microservices.md) | 61–96 | 35–70 | скрытие информации, DDD, сцепление |
| 3 | [03-splitting-the-monolith](chapters/03-splitting-the-monolith.md) | 97–114 | 71–88 | strangler, parallel run, data first |
| 4 | [04-communication-styles](chapters/04-communication-styles.md) | 115–146 | 89–120 | sync/async, события, request-response |
| 5 | [05-implementing-communication](chapters/05-implementing-communication.md) | 147–200 | 121–174 | RPC, REST, брокеры, схемы, discovery |
| 6 | [06-workflow](chapters/06-workflow.md) | 201–222 | 175–196 | 2PC нет, саги |
| 7 | [07-build](chapters/07-build.md) | 223–244 | 197–218 | CI, monorepo vs multirepo |
| 8 | [08-deployment](chapters/08-deployment.md) | 245–300 | 219–274 | контейнеры, k8s, progressive delivery |
| 9 | [09-testing](chapters/09-testing.md) | 301–330 | 275–304 | контракты, e2e, тест в проде |
| 10 | [10-observability](chapters/10-observability.md) | 331–370 | 305–344 | логи, метрики, трейс |
| 11 | [11-security](chapters/11-security.md) | 371–412 | 345–386 | zero trust, JWT, SSO |
| 12 | [12-resiliency](chapters/12-resiliency.md) | 413–444 | 387–418 | timeout, retry, **идемпотентность**, CAP |
| 13 | [13-scaling](chapters/13-scaling.md) | 445–480 | 419–454 | оси масштаба, **HTTP-кеш / ETag** |
| 14 | [14-user-interfaces](chapters/14-user-interfaces.md) | 481–516 | 455–490 | BFF, micro frontends |
| 15 | [15-organizational-structures](chapters/15-organizational-structures.md) | 517–550 | 491–524 | Conway, ownership |
| 16 | [16-evolutionary-architect](chapters/16-evolutionary-architect.md) | 551–576 | 525–548 | принципы, paved road |
| — | [17-afterword](chapters/17-afterword.md) | 577–588 | 551–562 | сжатые советы |

Кеш (гл. 13) и идемпотентность (гл. 12) у Newman — **разные** темы. Связка «HTTP-кеш делает запись идемпотентной» в книге не формулируется.

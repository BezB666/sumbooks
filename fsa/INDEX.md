# Fundamentals of Software Architecture — INDEX

Конспекты по [Fundamentals of Software Architecture](../books/Fundamentals_of_Software_Architecture_-_Mark_Richards.pdf) (Richards, Ford). PDF 589 стр. (конверсия ebook); печать ≈ PDF − 12 (гл. 1: PDF 13 = печать 1; сдвиг приблизительный). Текст книги в git не копировали.

Части: **I Foundations** (гл. 2–8), **II Architecture Styles** (гл. 9–18), **III Techniques and Soft Skills** (гл. 19–24). Гл. 1 — введение до части I.

**Как пользоваться:** `py tools/search.py "…" --book fsa` и [corpus/INDEX.md](../corpus/INDEX.md).

## Оглавление

| # | Файл | PDF | Печать | Что это |
|---|---|---|---|---|
| 1 | [01-introduction](chapters/01-introduction.md) | 13–39 | 1–27 | структура + characteristics + decisions; законы |
| 2 | [02-architectural-thinking](chapters/02-architectural-thinking.md) | 40–58 | 28–46 | архитектор vs разработчик, breadth, trade-offs |
| 3 | [03-modularity](chapters/03-modularity.md) | 59–82 | 47–70 | coupling, connascence, distance from main sequence |
| 4 | [04-architecture-characteristics-defined](chapters/04-architecture-characteristics-defined.md) | 83–97 | 71–85 | operational / structural / cross-cutting |
| 5 | [05-identifying-architectural-characteristics](chapters/05-identifying-architectural-characteristics.md) | 98–113 | 86–101 | explicit vs implicit, kata |
| 6 | [06-measuring-and-governing](chapters/06-measuring-and-governing.md) | 114–131 | 102–119 | fitness functions, cyclomatic complexity |
| 7 | [07-scope-of-architecture-characteristics](chapters/07-scope-of-architecture-characteristics.md) | 132–143 | 120–131 | architecture quantum |
| 8 | [08-component-based-thinking](chapters/08-component-based-thinking.md) | 144–167 | 132–155 | component, technical vs domain partitioning |
| 9 | [09-foundations](chapters/09-foundations.md) | 168–185 | 156–173 | style vs pattern; monolith vs distributed |
| 10 | [10-layered](chapters/10-layered.md) | 186–197 | 174–185 | Layered: просто и дёшево, плохо масштабируется |
| 11 | [11-pipeline](chapters/11-pipeline.md) | 198–205 | 186–193 | Pipeline / pipes and filters |
| 12 | [12-microkernel](chapters/12-microkernel.md) | 206–221 | 194–209 | Microkernel: core + plug-ins |
| 13 | [13-service-based](chapters/13-service-based.md) | 222–239 | 210–227 | Service-Based: pragmatic hybrid |
| 14 | [14-event-driven](chapters/14-event-driven.md) | 240–278 | 228–266 | EDA: broker vs mediator |
| 15 | [15-space-based](chapters/15-space-based.md) | 279–311 | 267–299 | Space-Based: in-memory, без БД в hot path |
| 16 | [16-orchestration-driven-soa](chapters/16-orchestration-driven-soa.md) | 312–322 | 300–310 | Orchestration-Driven SOA: урок reuse |
| 17 | [17-microservices](chapters/17-microservices.md) | 323–347 | 311–335 | Microservices: bounded context, кванты |
| 18 | [18-choosing-style](chapters/18-choosing-style.md) | 348–363 | 336–351 | как выбирать стиль: it depends |
| 19 | [19-architecture-decisions](chapters/19-architecture-decisions.md) | 364–386 | 352–374 | ADR; anti-patterns решений |
| 20 | [20-analyzing-architecture-risk](chapters/20-analyzing-architecture-risk.md) | 387–410 | 375–398 | risk matrix, risk storming |
| 21 | [21-diagramming](chapters/21-diagramming.md) | 411–423 | 399–411 | C4, UML, как показывать |
| 22 | [22-making-teams-effective](chapters/22-making-teams-effective.md) | 424–452 | 412–440 | границы команды, control freak |
| 23 | [23-negotiation](chapters/23-negotiation.md) | 453–476 | 441–464 | переговоры, 4 C’s, лидерство |
| 24 | [24-career-path](chapters/24-career-path.md) | 477–488 | 465–476 | 20-minute rule, technology radar |

# Learning Domain-Driven Design — INDEX

Конспекты по [Learning Domain-Driven Design](../books/Learning_Domain_Driven_Design_Aligning_Software_Architecture_and.pdf) (Vlad Khononov, O’Reilly). PDF 340 стр.; печатная страница = PDF − 26. Текст книги в git не копировали.

**Как пользоваться:** `py tools/search.py "…" --book ddd` и [corpus/INDEX.md](../corpus/INDEX.md).

Части: I Strategic Design (гл. 1–4), II Tactical Design (гл. 5–9), III Applying DDD (гл. 10–13), IV Relationships to other methodologies (гл. 14–16).

## Оглавление

| # | Файл | PDF | Печать | Что это |
|---|---|---|---|---|
| 1 | [01-analyzing-business-domains](chapters/01-analyzing-business-domains.md) | 29–46 | 3–20 | core / supporting / generic subdomains |
| 2 | [02-discovering-domain-knowledge](chapters/02-discovering-domain-knowledge.md) | 47–58 | 21–32 | ubiquitous language |
| 3 | [03-managing-domain-complexity](chapters/03-managing-domain-complexity.md) | 59–74 | 33–48 | bounded context vs subdomain |
| 4 | [04-integrating-bounded-contexts](chapters/04-integrating-bounded-contexts.md) | 75–88 | 49–62 | partnership, shared kernel, ACL, OHS, context map |
| 5 | [05-implementing-simple-business-logic](chapters/05-implementing-simple-business-logic.md) | 89–100 | 63–74 | Transaction Script, Active Record (Fowler) |
| 6 | [06-tackling-complex-business-logic](chapters/06-tackling-complex-business-logic.md) | 101–124 | 75–98 | Domain Model, aggregates, value objects, domain events |
| 7 | [07-modeling-the-dimension-of-time](chapters/07-modeling-the-dimension-of-time.md) | 125–142 | 99–116 | Event Sourcing |
| 8 | [08-architectural-patterns](chapters/08-architectural-patterns.md) | 143–162 | 117–136 | layered, Ports & Adapters, CQRS |
| 9 | [09-communication-patterns](chapters/09-communication-patterns.md) | 163–184 | 137–158 | model translation, Outbox, Saga, Process Manager |
| 10 | [10-design-heuristics](chapters/10-design-heuristics.md) | 185–194 | 159–168 | heuristics / decision tree |
| 11 | [11-evolving-design-decisions](chapters/11-evolving-design-decisions.md) | 195–210 | 169–184 | эволюция TS→AR→DM→ES |
| 12 | [12-eventstorming](chapters/12-eventstorming.md) | 211–226 | 185–200 | шаги EventStorming |
| 13 | [13-ddd-in-the-real-world](chapters/13-ddd-in-the-real-world.md) | 227–242 | 201–216 | brownfield, pragmatic DDD |
| 14 | [14-microservices](chapters/14-microservices.md) | 243–258 | 217–232 | microservice = BC, не один aggregate; OHS/ACL |
| 15 | [15-event-driven-architecture](chapters/15-event-driven-architecture.md) | 259–274 | 233–248 | events vs commands, coupling via events |
| 16 | [16-data-mesh](chapters/16-data-mesh.md) | 275–292 | 249–266 | data mesh vs warehouse/lake |
| 17 | [17-closing-words](chapters/17-closing-words.md) | 293–298 | 267–272 | сводка книги |

Appendix A (case study), упражнения, references, index — PDF 299–340, не конспектировали.

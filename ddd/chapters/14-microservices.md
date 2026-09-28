# Глава 14. Microservices

- **PDF:** 243–258 (печать 217–232)
- **Якоря:** microservice, bounded context, aggregate, subdomain, deep module, open-host service, anticorruption layer

Сервис = доступ к capability через публичный интерфейс («входная дверь»). **Microservice** — сервис с *micro* публичным интерфейсом, БД не торчит наружу. «Один метод = один сервис» даёт distributed big ball of mud: локально просто, глобально ад. Цель — баланс local vs global complexity. Хороший модуль **глубокий** (Ousterhout): узкий интерфейс, толстая логика.

Все МС — **bounded contexts**, но не каждый BC — МС: BC — *самая широкая* валидная граница модели; МС — ближе к *узкой* полезной. Резать **один aggregate** в сервис часто мелко (shallow). Безопасная эвристика — граница **subdomain** (связные use cases). **OHS** сжимает дверь published language; **ACL** (в т.ч. отдельным сервисом) снимает интеграционную сложность с потребителя.

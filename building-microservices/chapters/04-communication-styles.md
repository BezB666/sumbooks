# Глава 4. Microservice Communication Styles

- **PDF:** 115–146 (печать 89–120)
- **Якоря:** synchronous blocking, asynchronous, request-response, event-driven, common data, timeout, retry, idempotency, EIP

Из процесса наружу: латентность, эволюция интерфейса, ошибки. Стили: синхронный блокирующий, асинхронный, общая дата, request-response, события. Таймаут синхронного вызова **не говорит**, дошёл ли запрос — отсюда идемпотентность (разбор в гл. 12). Ссылается на EIP Hohpe/Woolf. Автор тяготеет к async/events, но пишет про цену сложности.

# Глава 13. Scaling

- **PDF:** 445–480 (печать 419–454)
- **Якоря:** caching, Cache-Control, Expires, ETag, If-None-Match, conditional GET, 304 Not Modified, TTL, cache poisoning, autoscaling

Четыре оси масштаба + **кеш** (печать 435+, PDF 461+): ради latency, масштаба, иногда устойчивости. Где кешировать; инвалидация. HTTP: TTL через Cache-Control/Expires; **conditional GET** + ETag + If-None-Match → 304, чтобы не пересобирать дорогой ответ. Это про свежесть и стоимость чтения, **не** про идемпотентную запись. Notification-based invalidation через события. Golden rule / poisoning / autoscaling.

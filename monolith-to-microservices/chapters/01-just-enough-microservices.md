# Глава 1. Just Enough Microservices

- **PDF:** 18–49 (печать 1–32)
- **Якоря:** independent deployability, own data, bounded context, aggregate, monolith, modular monolith, distributed monolith

МС — независимо деплоемые сервисы вокруг бизнес-домена: меняешь один, выкатываешь его, не выкатывая остальных. Это SOA с жёстким акцентом на **independent deployability** и скрытие БД: чужой сервис ходит за данными через интерфейс; shared DB ломает слабое сцепление. Cohesion — по бизнес-функции (Conway), не по слоям UI/логика/БД. Размер вторичен; k8s/облако/язык не обязательны.

Монолит здесь — единица деплоя: single-process, **modular monolith** (Shopify), **distributed monolith** (сервисы, которые всегда катят вместе), third-party black-box. Монолит — валидный выбор, не синоним legacy. DDD: **aggregate** — state machine одного понятия (Order, Invoice); **bounded context** — оргграница с несколькими агрегатами. На старте сервис ≈ bounded context; дробить потом по aggregate, пряча это за грубым API.

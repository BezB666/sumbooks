# Глава 7. Distribution Strategies

- **PDF:** 112–119 (печать 87–94)
- **Якоря:** First Law of Distributed Object Design, remote vs local interface, clustering, Remote Facade, Data Transfer Object

Провал: Customer/Order/Product каждый на своём узле «ради производительности». Локальный вызов быстрый, межпроцессный — на порядки медленнее. Локальный интерфейс мелкозернистый; удалённый — coarse-grained. Класс, который *может* стать remote, платит за грубый API всегда.

**First Law of Distributed Object Design: don't distribute your objects.** Узлы — кластером одной копии приложения, внутри локальные вызовы. Граница всё равно: desktop↔сервер, app↔БД, иногда web↔app, вендорский процесс. На границе: Remote Facade (только делегирует) + Data Transfer Object (не слать граф домена). XML/HTTP — кросс-платформа; одна платформа — нативный RPC. Fowler предпочитает async messaging, в книгу его не кладёт.

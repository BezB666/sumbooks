# Глава 9. Communication Patterns

- **PDF:** 163–184 (печать 137–158)
- **Якоря:** model translation, anticorruption layer, open-host service, Outbox, Saga, Process Manager

**Model translation** обслуживает ACL (downstream) и OHS (upstream): одна и та же идея перевода. Stateless — proxy на лету (sync в коде, async — отдельный трансформер). Stateful — когда надо агрегировать, батчить или сливать источники.

**Outbox:** состояние aggregate и исходящие события в одной транзакции БД; relay читает и публикует; at-least-once (дедуп на потребителе). Иначе: событие ушло, транзакция откатилась — или наоборот.

**Saga** — длинный процесс из нескольких транзакций: слушает события, шлёт команды, компенсирует сбои. Состояния участников eventually consistent; не затычка для кривых границ aggregate. **Process Manager** — не линейный match event→command, а ветвящийся workflow со своим состоянием (часто сам aggregate). Оба опираются на async + Outbox.

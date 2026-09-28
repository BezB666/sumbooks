# Глава 4. Encoding and Evolution

- **PDF:** 133–172 (печать 111–150)
- **Якоря:** schema evolution, backward compatibility, forward compatibility, rolling upgrade, REST, RPC, message broker

Фичи меняют данные. RDBMS: один schema в момент времени (ALTER). Schema-on-read: в сторе смесь эпох. Код и данные не обновляются мгновенно → **rolling upgrade**: ноды на разных версиях сразу. Нужны backward (новый код читает старое) и forward (старый код читает новое) compatibility.

Кодировки: языковые сериализации часто без совместимости и опасны. JSON/XML/CSV — везде, типы размыты. Thrift / Protobuf / Avro — компактно, правила эволюции явные, без декода человеку не прочитать.

Три потока байтов. БД: писатель кодирует, читатель потом декодирует. **REST** (HTTP, обычно JSON) — публичные API; **RPC** (gRPC и т.п.) — сервисы одной орг., один ДЦ; сеть ≠ локальный вызов (location transparency — ложь). Для эволюции RPC: сначала серверы, потом клиенты. **Message-passing:** брокер буферит, ределивирит, fan-out, развязывает адреса; обычно one-way, ответ — другой канал.

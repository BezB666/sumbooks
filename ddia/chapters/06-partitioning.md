# Глава 6. Partitioning

- **PDF:** 221–242 (печать 199–220)
- **Якоря:** partition, shard, key-range partitioning, hash partitioning, hot spot, secondary index, rebalancing, request routing

Партиция здесь — намеренный раскол большого стора, **не** network partition. Синонимы: shard, region, tablet, vnode. Каждая запись в ровно одной партиции; цель — scalability на shared-nothing, без **hot spots**.

**Key range:** ключи отсортированы, range-запросы дёшевы, соседние ключи могут ударить в одну партицию. Ребаланс — резать range. **Hash:** нагрузка ровнее, порядок ключей убит. Гибрид: часть ключа — партиция, часть — сорт.

Вторичные индексы тоже режут. **Document-partitioned** (local): апдейт одной партиции, чтение — scatter/gather по всем. **Term-partitioned** (global): чтение с одной, запись трогает много.

Ребаланс: двигать целые партиции или сплит range. Авто vs руками. Роутинг: тир (Helix/ZK, mongos) или gossip (Cassandra/Riak). MPP-аналитика умеет параллелить сложный SQL — отсылка к гл. 10.

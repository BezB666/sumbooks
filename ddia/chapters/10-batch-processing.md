# Глава 10. Batch Processing

- **PDF:** 411–460 (печать 389–438)
- **Якоря:** batch processing, MapReduce, HDFS, Unix philosophy, derived data, bounded input

Три класса систем: **online** (запрос → ответ, latency), **batch/offline** (проглотить большой вход, throughput), **stream/nearline** (события сразу после факта — гл. 11). Batch старше компьютеров (Hollerith, IBM card sorters); MapReduce — тот же дух на commodity cluster.

Unix: вход иммутабелен, выход — вход ещё неизвестной программы, мелкие инструменты «делают одно дело». В Hadoop униформа — распределённая ФС; dataflow-движки не материализуют промежуточное на HDFS, но края джобы всё равно файлы.

Две задачи фреймворка: **partitioning** (собрать записи с одним ключом у одного reducer) и **fault tolerance** (MapReduce часто пишет диск — дешёвый retry таска; in-memory dataflow пересчитывает больше). Joins: sort-merge, broadcast hash, partitioned hash. Колбэки без побочек → retry безопасен; видимый выход «как будто сбоев не было».

Главное: выход **derived** из **bounded** входа фиксированного размера; джоба знает, когда кончила. Stream — тот же пайплайн, но вход никогда не кончается.

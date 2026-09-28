# Глава 11. Evolving Design Decisions

- **PDF:** 195–210 (печать 169–184)
- **Якоря:** Transaction Script, Active Record, Domain Model, Event Sourcing, partnership, separate ways

Типы subdomain плывут: core→generic (появился off-the-shelf), generic→core (своё лучше рынка, AWS), supporting→generic (opensource), supporting→core (логика усложнилась и стала прибыльной), и обратно. Strategic: core защищают ACL/OHS; separate ways для нового core больше нельзя; supporting можно outsource, core — нет.

Tactical сигнал — боль: TS/AR не держат новые инварианты. Миграции: **TS → AR** (спрятать маппинг данных); **AR → Domain Model** (VO, private setters, границы aggregate); **DM → event-sourced** — либо приближённый стрим прошлых событий, либо явное `migrated-from-legacy`. Оргизменения: partnership → customer–supplier; при политике — separate ways. Рост без пересмотра границ → big ball of mud: дробить subdomain, не давать BC стать «для всего», держать aggregate маленькими.

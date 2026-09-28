# Глава 4. Integrating Bounded Contexts

- **PDF:** 75–88 (печать 49–62)
- **Якоря:** partnership, shared kernel, customer–supplier, conformist, anticorruption layer, open-host service, published language, separate ways, context map

BC независимы в эволюции, но не в работе: нужны контракты. Паттерны группируют по тому, как команды сотрудничают.

**Cooperation:** **partnership** — ad hoc, двусторонняя координация (плохо для геораспределённых команд); **shared kernel** — общий кусок модели, сильная связка, CI на каждое изменение; оправдан, если дублирование дороже координации (часто core); формально ломает «один BC — одна команда». **Customer–supplier:** upstream/downstream. **Conformist** — потребитель принимает модель поставщика as-is. **Anticorruption layer (ACL)** — переводит чужую модель в свою (core, легаси, частые ломающие изменения). **Open-host service (OHS)** — поставщик публикует **published language**, отдельный от внутренней модели, можно несколько версий. **Separate ways** — дешевле дублировать, чем интегрировать; **не для core**. **Context map** рисует BC и связи: дизайн, коммуникация, оргпроблемы.

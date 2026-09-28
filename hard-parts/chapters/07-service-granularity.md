# Глава 7. Service Granularity (Гранулярность сервисов)

- **PDF:** 318–347 (печать 306–335)
- **Якоря:** modularity vs granularity (модульность vs гранулярность), disintegrators (дезинтеграторы), integrators (интеграторы), single-responsibility (единственная ответственность)

Домены нарезаны, команда спорит про размер. Addison: ticket creation / completion / assignment / routing — один сервис или четыре? Austen: customer registration / profile / billing — резать ли? Tech lead Taylen: «micro значит маленький, SRP, всё в мелкие сервисы». Logan: не каждая часть приложения должна быть микросервисом — это типичная яма стиля. Пример notification: SMS + email + письмо. Taylen — три сервиса («каждый канал — своё»). Addison — один («уведомление и есть ответственность»). Austen — не знает, монетку бросать? Вывод: SRP слишком субъективен; «одно statements / один класс / один публичный метод» — не метрика.

**Modularity** (модульность) — *резать систему*. **Granularity** (гранулярность) — *размер получившегося куска*. Смотрят, *что делает* сервис (операции, cohesion), не LOC.

Две силы, как у данных. **Disintegrators** (когда мельчить): слабая связность scope/function, разный code volatility (тикеты меняют часто, справочник — нет), разный scale/throughput, fault tolerance (падение assignment не должно валить создание тикета), security, extensibility (но не гадать «а вдруг»; лучше дождаться паттерна использования). **Integrators** (когда склеить обратно): нужен ACID между кусками, workflow/choreography становится челноком, shared code, data relationships (чужие таблицы → удалённые вызовы на каждый чих). Правильный размер — равновесие, не «резать пока micro».

Sysops: **ADR — один сервис assignment+routing** (алгоритмы жёстко связаны, один профиль нагрузки; цена — общий деплой при смене алгоритма). **ADR — не дробить customer-related** (registration/profile/billing) без драйвера; «это разные функции» само по себе не аргумент.

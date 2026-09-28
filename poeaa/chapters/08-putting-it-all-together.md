# Глава 8. Putting It All Together

- **PDF:** 120–133 (печать 95–108)
- **Якоря:** Transaction Script, Domain Model, Table Module, Data Mapper, MVC, First Law, J2EE, .NET, Web services

Сначала домен: скрипты — простой каталог; Domain Model — сложные правила (+ дорогой O/R); Table Module — середина и звезда .NET из-за Record Set. Скрипты → Table/Row Data Gateway; правка в два запроса — Optimistic Offline Lock. Простая модель ≈ таблицы → Active Record; сложнее → Data Mapper и Unit of Work. HTML если можно; MVC; документный сайт — Page Controller, сложная навигация — Front; всё в одном процессе, иначе Remote Facade + DTO.

Java 2002: EJB не обязателен. Богатая модель — POJO + Data Mapper, session beans только фасады; entity beans без remote-интерфейса. .NET — Table Module по умолчанию. Web services внутрь приложения не пихать (First Law, гл. 7). Stored procedures — точечная оптимизация, доступ всё равно прятать Gateway. Чужие схемы слоёв — те же три плюс необязательные медиаторы (Application Controller, Data Mapper, Service Layer).

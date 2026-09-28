# Глава 4. Web Presentation

- **PDF:** 80–87 (печать 55–62)
- **Якоря:** MVC, input controller, Application Controller, Page Controller, Front Controller, Template View, Transform View, Two Step View

Скрипт (servlet) удобен разбирать запрос, server page — собирать HTML. Смесь «скрипт на вход + страница на выход» — MVC: input controller снимает HTTP, зовёт модель, выбирает view. Модель не знает про Web. **Application Controller** (другой смысл слова) задаёт порядок экранов; нужен, если машине решать, какой экран следующий.

View: Template (макет + маркеры; логику в helper, не в scriptlet) vs Transform (XSLT). Один этап ≈ экран; Two Step View — логический экран, потом один второй этап на всё приложение (общий HTML, мультибренд). Input: Page Controller на действие vs Front Controller — один вход, меньше конфигов веб-сервера.

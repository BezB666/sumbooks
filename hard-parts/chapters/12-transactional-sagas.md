# Глава 12. Transactional Sagas (Транзакционные саги)

- **PDF:** 558–643 (печать 546–631)
- **Якоря:** Epic Saga, Phone Tag, Fairy Tale, Time Travel, Fantasy Fiction, Horror Story, Parallel Saga, Anthology, compensation (компенсация), state machine (машина состояний)

Austen приносит дизайн ticketing workflow; Addison: «ты сделал horror story, иди к Logan». Logan сразу угадывает: async + atomic + choreography. Это не «сага Richardson как единственный паттерн», а **одна клетка матрицы** из трёх осей гл. 2: communication × consistency × coordination. Термин saga старше микросервисов (бумага 1987 про ограничение локов); Richardson описывает цепочку локальных транзакций + compensation. Книга показывает: атомарности *между* сервисами нет; интересны отказы, не happy path. Паттерн ≠ чистое решение: distributed transactions имеют legendary failure modes.

Восемь комбинаций (имена — мнемоника trade-off’ов):

| Pattern | Оси | Что происходит / цена |
|---|---|---|
| Epic Saga (эпическая) | sync + atomic + orchestrated | «как монолитная транзакция по сети». Coupling very high; complexity низкая; resp/scale very low |
| Phone Tag Saga («испорченный телефон») | sync + atomic + choreographed | Атомарность без дирижёра: сервисы синхронно передают «всё или ничего». Coupling/complexity high; resp/scale low |
| Fairy Tale Saga (сказка) | sync + eventual + orchestrated | Дирижёр есть, атомарности между сервисами нет. Coupling high; complexity very low; resp medium, scale high |
| Time Travel Saga (путешествие во времени) | sync + eventual + choreographed | Синхронные вызовы, eventual, без центра. Coupling medium; complexity low; resp medium, scale high |
| Fantasy Fiction Saga (фэнтези) | async + atomic + orchestrated | Хочется и очередь, и «всё или ничего». Coupling/complexity high; resp/scale low |
| Horror Story (ужастик) | async + atomic + choreographed | **Антипаттерн**: атомарность без оркестратора на асинхронных сообщениях. Complexity very high; resp low |
| Parallel Saga (параллельная) | async + eventual + orchestrated | Дирижёр запускает шаги параллельно, согласованность потом. Coupling/complexity low; resp/scale high |
| Anthology Saga (антология) | async + eventual + choreographed | Максимальная развязка; каждый сам, ошибки — сеть компенсаций. Coupling very low; complexity high; resp high, scale very high |

**Compensation** (компенсация): откат к прежнему состоянию отдельным действием. Нет isolation (другой пользователь уже видел промежуточное), есть side effects (письмо уже ушло), компенсация сама может упасть, UX хуже («мы пытаемся отменить»). Альтернатива — **state machine** (машина состояний) + eventual (retry / ручное), без немедленного undo. Корреляции, которые гл. 15 потом обобщает: больше coupling → хуже scale и availability.

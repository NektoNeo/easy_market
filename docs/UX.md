
# UX

## Навигация
- Wizard (Create) → Results (Generate output) → Save → History → Open Results

Роуты (Flutter, `go_router`):
- `/wizard`
- `/results` (передаём id записи истории или объект результата в extra)
- `/history`

## Экран Wizard
Цель: **минимум кликов** и понятный прогресс.

### Step 1 — Basics
- marketplace (WB/Ozon/Avito/Other)
- category
- product_name
- brand (optional)
- characteristics (key/value chips), variants (optional)

### Step 2 — Audience & tone
- audience
- tone (neutral/friendly/premium/strict)
- forbidden words chips
- forbidden claims toggles (упрощённо)

### Step 3 — Output & Generate
- output options (counts/toggles)
- primary CTA: Generate

## Экран Results
- Top summary карточки: product_name + marketplace + category
- Если `missing_info_questions` не пуст:
  - карточка “Нужно уточнить” + быстрые поля ответа + кнопка “Перегенерировать”
- Если `risk_flags`:
  - карточка “Риски” (severity + snippet)
- Tabs: Titles / Bullets / Descriptions / SEO / FAQ / Replies
- Copy actions: “Copy all” + “Copy per section”
- Inline edit + Save to history

## Экран History
- список генераций (дата/маркетплейс/название)
- поиск (по названию/категории)
- удалить

---

## Glassmorphism (правила)
- Фон: subtle gradient.
- Glass cards:
  - blur 16
  - opacity 0.10–0.18
  - border 1px low opacity
  - rounded corners 20–28
- Не больше 2 “стеклянных” слоёв одновременно.
- Large typography, generous spacing, минимум декоративных элементов.
- Опция “Reduce Transparency” (настройка приложения) отключает blur и повышает контраст.

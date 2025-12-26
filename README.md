
# Packager — “Упаковка товара для маркетплейса за 3 минуты”

Монорепозиторий содержит:

- `backend/` — **mock‑first** FastAPI API (по умолчанию работает без ключей и возвращает детерминированный мок‑ответ).
- `app/` — Flutter приложение (Android + iOS) с **glassmorphism UI (2025)**: Wizard → Results → History.
- `docs/` — продуктовые и технические документы (UX, API, prompting, QA).

> ⚠️ Важная политика: генератор **не имеет права выдумывать факты о товаре**.  
> Если данных не хватает — возвращает `missing_info_questions` и подсказки.

---

## Быстрый старт

### 1) Backend (FastAPI)

Требования: Python 3.11+

```bash
cd backend
python -m venv .venv
# Windows: .venv\Scripts\activate
source .venv/bin/activate

pip install -e ".[dev]"
pytest
uvicorn app.main:app --reload --port 8000
```

Проверка:

- `GET http://localhost:8000/healthz`
- `GET http://localhost:8000/v1/templates`
- `POST http://localhost:8000/v1/generate/packaging`

По умолчанию провайдер: `mock`.

Переключение провайдера (заглушки с TODO):

```bash
export PACKAGER_PROVIDER=yandex   # или gigachat
```

---

### 2) Mobile (Flutter)

Требования: Flutter 3.38.5 (проверено).

#### Важно про зависимости (Flutter)
- `app/pubspec.lock` **коммитим всегда**.
- CI падает, если `pubspec.lock` не закоммичен или меняется после `flutter pub get`.

#### Важно про запуск на устройстве
Если в папке `app/` нет директорий `android/` и `ios/`, то это пока “пакет/кодовая база”.
Чтобы получить полноценное Android+iOS приложение для `flutter run`, один раз сгенерируйте платформы:

```bash
cd app
flutter create . --platforms=android,ios
```

После этого `flutter run` будет работать (и это лучше тоже закоммитить, когда определитесь с bundle id/организацией).

> Если вы уже сгенерировали `android/` и `ios/` — тогда наоборот: просто убедитесь, что они **есть в git** и README не предлагает “создавать заново”.

```bash
cd app
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze --fatal-infos --fatal-warnings
flutter test
# (опционально) integration_test — локально с устройством/эмулятором
```

Запуск:

```bash
flutter run
```

API URL:

- Android Emulator: `http://10.0.2.2:8000`
- iOS Simulator: `http://localhost:8000`

Можно переопределить через `--dart-define`:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

---

## Архитектура (кратко)

### Backend

- `app/models.py` — **единые Pydantic модели** (request/response, схемы).
- `app/providers/mock.py` — мок‑провайдер (детерминированные ответы).
- `app/services/generator.py` — PromptBuilder + risk detection + вызов провайдера.
- `app/schemas/*.schema.json` — JSON schema (для контрактных тестов).

### Flutter

- `lib/main.dart` + `lib/app.dart` — вход и роутинг.
- `lib/l10n/*` — локализация (без “магических строк” в UI).
- `lib/ui/*` — экраны и glass‑компоненты.
- `lib/data/*` — API client + history store + seed templates.

---

## CI

GitHub Actions:

- Python: ruff + black + pytest
- Flutter: format + analyze + test

См. `.github/workflows/ci.yml`.

---

## Лицензия

MIT (можно заменить/уточнить под продуктовые требования).

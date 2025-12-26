
# QA

## Test matrix (MVP)
### Backend
- Endpoint contract: response валиден по JSON schema
- Mock provider: детерминированность (один вход → один выход)
- Validation: pydantic errors на плохом request
- Rate limiting: 429 после превышения

### Flutter
- Unit:
  - validators
  - DTO ↔ domain mapping
  - prompt options logic
- Widget:
  - wizard flow (stepper)
  - results tabs render
  - history list render
  - error state UI
- Integration (локально):
  - заполнить wizard → generate → увидеть результат → сохранить → открыть из history

## Manual checklist
- Нет “магических строк” — всё через l10n.
- Glass UI читаем на светлой/тёмной теме.
- Поля ввода имеют валидацию и понятные подсказки.
- Кнопка Generate недоступна пока обязательные поля не заполнены.
- В Results видны missing questions и risk flags.

## Release smoke
- Backend: `/healthz` и generate
- App: wizard→results→copy→history

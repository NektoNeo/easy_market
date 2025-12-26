
# Packager API (FastAPI)

## Run (dev)
```bash
python -m venv .venv
source .venv/bin/activate
pip install -e ".[dev]"
uvicorn app.main:app --reload --port 8000
```

## Provider selection
Default: `mock`

Set:
```bash
export PACKAGER_PROVIDER=mock|yandex|gigachat
```

> `yandex` и `gigachat` провайдеры — заглушки с TODO.

## Tests
```bash
pytest -q
```

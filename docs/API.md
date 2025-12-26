
# API

Base URL (dev): `http://localhost:8000`

## Health
`GET /healthz`

Response:
```json
{ "ok": true }
```

## Templates
`GET /v1/templates`

Response:
```json
{
  "templates": [
    {
      "id": "cosmetics",
      "name": "Косметика",
      "description": "Шаблон под косметику и уход",
      "defaults": { "tone": "friendly", "faq_count": 8 }
    }
  ]
}
```

## Generate packaging
`POST /v1/generate/packaging`

Request example:
```json
{
  "marketplace": "WB",
  "category": "Уход за лицом",
  "product_name": "Крем для рук",
  "brand": "MyBrand",
  "characteristics": [{ "k": "Объём", "v": "50 мл" }],
  "variants": [],
  "audience": "Люди с сухой кожей",
  "tone": "friendly",
  "forbidden_words": ["лечит", "100%"],
  "forbidden_claims": ["medical"],
  "output_options": {
    "title_variants": 5,
    "bullets_count": 6,
    "need_short_description": true,
    "need_long_description": true,
    "need_seo": true,
    "faq_count": 10,
    "review_replies_per_sentiment": 3
  },
  "language": "ru",
  "installation_id": "00000000-0000-0000-0000-000000000000"
}
```

Response example (схема сокращена):
```json
{
  "meta": {
    "request_id": "req_...",
    "provider": "mock",
    "model": "mock-1",
    "latency_ms": 42
  },
  "missing_info_questions": [],
  "risk_flags": [],
  "outputs": {
    "titles": ["..."],
    "bullets": ["..."],
    "description_short": "...",
    "description_long": "...",
    "seo_keywords": ["..."],
    "faq": [{"q":"...","a":"..."}],
    "review_replies": {
      "positive": ["..."],
      "neutral": ["..."],
      "negative": ["..."]
    }
  },
  "compliance_notes": ["..."]
}
```

## Error codes (общие)
- `400` — validation error
- `429` — rate limit
- `500` — internal error

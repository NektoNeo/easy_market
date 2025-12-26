
import json

import pytest
import httpx
from jsonschema import Draft202012Validator

from app.main import app


@pytest.mark.asyncio
async def test_contract_response_matches_json_schema():
    payload = {
        "marketplace": "OZON",
        "category": "Электроника",
        "product_name": "Кабель USB-C",
        "brand": None,
        "characteristics": [{"k": "Длина", "v": "1 м"}, {"k": "Разъём", "v": "USB-C"}],
        "variants": [],
        "audience": "Пользователи смартфонов и ноутбуков",
        "tone": "strict",
        "forbidden_words": [],
        "forbidden_claims": [],
        "output_options": {
            "title_variants": 3,
            "bullets_count": 4,
            "need_short_description": True,
            "need_long_description": True,
            "need_seo": True,
            "faq_count": 3,
            "review_replies_per_sentiment": 1,
        },
        "language": "ru",
        "installation_id": "22222222-2222-2222-2222-222222222222",
    }

    schema_path = "app/schemas/packaging_response.schema.json"
    with open(schema_path, "r", encoding="utf-8") as f:
        schema = json.load(f)

    validator = Draft202012Validator(schema)

    transport = httpx.ASGITransport(app=app)
    async with httpx.AsyncClient(transport=transport, base_url="http://test") as ac:
        r = await ac.post("/v1/generate/packaging", json=payload)
        assert r.status_code == 200
        data = r.json()

    errors = sorted(validator.iter_errors(data), key=lambda e: e.path)
    assert errors == []

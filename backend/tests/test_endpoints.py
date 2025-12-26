
import pytest
import httpx

from app.main import app


@pytest.mark.asyncio
async def test_healthz():
    transport = httpx.ASGITransport(app=app)
    async with httpx.AsyncClient(transport=transport, base_url="http://test") as ac:
        r = await ac.get("/healthz")
        assert r.status_code == 200
        body = r.json()
        assert body["ok"] is True


@pytest.mark.asyncio
async def test_templates():
    transport = httpx.ASGITransport(app=app)
    async with httpx.AsyncClient(transport=transport, base_url="http://test") as ac:
        r = await ac.get("/v1/templates")
        assert r.status_code == 200
        data = r.json()
        assert "templates" in data
        assert len(data["templates"]) >= 1
        assert data["templates"][0]["id"]


@pytest.mark.asyncio
async def test_generate_packaging_mock():
    payload = {
        "marketplace": "WB",
        "category": "Уход за лицом",
        "product_name": "Крем для рук",
        "brand": "MyBrand",
        "characteristics": [{"k": "Объём", "v": "50 мл"}, {"k": "Аромат", "v": "без отдушки"}],
        "variants": [],
        "audience": "Люди с сухой кожей",
        "tone": "friendly",
        "forbidden_words": ["лечит", "100%"],
        "forbidden_claims": ["medical"],
        "output_options": {
            "title_variants": 5,
            "bullets_count": 6,
            "need_short_description": True,
            "need_long_description": True,
            "need_seo": True,
            "faq_count": 5,
            "review_replies_per_sentiment": 2,
        },
        "language": "ru",
        "installation_id": "00000000-0000-0000-0000-000000000000",
    }
    transport = httpx.ASGITransport(app=app)
    async with httpx.AsyncClient(transport=transport, base_url="http://test") as ac:
        r = await ac.post("/v1/generate/packaging", json=payload)
        assert r.status_code == 200
        data = r.json()
        assert "meta" in data
        assert data["meta"]["provider"] in ["mock", "yandex", "gigachat"]
        assert "outputs" in data
        assert isinstance(data["outputs"]["titles"], list)

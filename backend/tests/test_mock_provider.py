import pytest

from app.models import PackagingRequest
from app.providers.mock import MockLLMProvider


@pytest.mark.asyncio
async def test_mock_provider_is_deterministic():
    req = PackagingRequest(
        marketplace="WB",
        category="Одежда",
        product_name="Футболка базовая",
        brand="BrandX",
        characteristics=[{"k": "Материал", "v": "хлопок 100%"}, {"k": "Цвет", "v": "чёрный"}],
        variants=[],
        audience="Повседневная носка",
        tone="neutral",
        forbidden_words=[],
        forbidden_claims=[],
        output_options={
            "title_variants": 5,
            "bullets_count": 6,
            "need_short_description": True,
            "need_long_description": True,
            "need_seo": True,
            "faq_count": 5,
            "review_replies_per_sentiment": 2,
        },
        language="ru",
        installation_id="11111111-1111-1111-1111-111111111111",
    )

    p = MockLLMProvider()
    a = await p.generate_packaging(req)
    b = await p.generate_packaging(req)

    assert a.meta.request_id == b.meta.request_id
    assert a.outputs.titles == b.outputs.titles
    assert a.outputs.bullets == b.outputs.bullets

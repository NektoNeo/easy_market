from __future__ import annotations

import time
from collections import defaultdict, deque
from typing import Annotated

from fastapi import Depends, FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware

from app.config import settings
from app.models import (
    PackagingRequest,
    PackagingResponse,
    SeedTemplate,
    TemplateDefaults,
    TemplatesResponse,
)
from app.providers.base import LLMProvider
from app.providers.gigachat import GigaChatProvider
from app.providers.mock import MockLLMProvider
from app.providers.yandex import YandexProvider
from app.services.generator import generate


class RateLimiter:
    """
    Simple in-memory limiter for MVP.

    TODO(P1): replace with Redis / shared storage for multi-replica deployments.
    """

    def __init__(self, limit_per_minute: int):
        self.limit = limit_per_minute
        self._events: defaultdict[str, deque[float]] = defaultdict(deque)

    def check(self, key: str) -> None:
        now = time.time()
        q = self._events[key]
        # purge older than 60s
        while q and now - q[0] > 60:
            q.popleft()
        if len(q) >= self.limit:
            raise HTTPException(
                status_code=429,
                detail=(
                    "Rate limit exceeded. Try again later. "
                    f"limit_per_minute={self.limit}"
                ),
            )
        q.append(now)


rate_limiter = RateLimiter(limit_per_minute=settings.rate_limit_per_minute)


def get_provider() -> LLMProvider:
    if settings.provider == "mock":
        return MockLLMProvider()
    if settings.provider == "yandex":
        return YandexProvider()
    if settings.provider == "gigachat":
        return GigaChatProvider()
    return MockLLMProvider()


SEED_TEMPLATES: list[SeedTemplate] = [
    SeedTemplate(
        id="cosmetics",
        name="Косметика",
        description="Уход, кремы, шампуни (без медицинских обещаний).",
        defaults=TemplateDefaults(tone="friendly", faq_count=8),
    ),
    SeedTemplate(
        id="clothes",
        name="Одежда",
        description="Футболки, платья, куртки (акцент на состав/размеры).",
        defaults=TemplateDefaults(tone="neutral", faq_count=6),
    ),
    SeedTemplate(
        id="electronics",
        name="Электроника",
        description="Гаджеты, аксессуары (совместимость, параметры).",
        defaults=TemplateDefaults(tone="strict", faq_count=8),
    ),
    SeedTemplate(
        id="home",
        name="Дом",
        description="Товары для дома и кухни (материалы, размеры).",
        defaults=TemplateDefaults(tone="neutral", faq_count=6),
    ),
]

app = FastAPI(title="Packager API", version="0.1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/healthz")
async def healthz():
    return {"ok": True, "provider": settings.provider}


@app.get("/v1/templates", response_model=TemplatesResponse)
async def templates() -> TemplatesResponse:
    return TemplatesResponse(templates=SEED_TEMPLATES)


@app.post("/v1/generate/packaging", response_model=PackagingResponse)
async def generate_packaging(
    req: PackagingRequest,
    provider: Annotated[LLMProvider, Depends(get_provider)],
) -> PackagingResponse:
    rate_limiter.check(req.installation_id)
    try:
        return await generate(req, provider)
    except NotImplementedError as e:
        raise HTTPException(status_code=501, detail=str(e)) from e


@app.post("/v1/usage/consume")
async def usage_consume():
    # Optional for future: server-side quota tracking / billing hooks.
    # TODO(P2): implement if needed.
    return {"ok": True}

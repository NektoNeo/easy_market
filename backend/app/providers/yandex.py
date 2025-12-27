from __future__ import annotations

from app.models import PackagingRequest, PackagingResponse
from app.providers.base import LLMProvider


class YandexProvider(LLMProvider):
    @property
    def name(self) -> str:
        return "yandex"

    @property
    def model(self) -> str:
        return "TODO"

    async def generate_packaging(self, req: PackagingRequest) -> PackagingResponse:
        # TODO(P1,backend): Implement YandexGPT / Model Gallery integration.
        # - Read API key from env / secret store
        # - Build prompt template from services/generator.py
        # - Call provider endpoint and parse JSON
        raise NotImplementedError("YandexProvider is not implemented yet (TODO).")

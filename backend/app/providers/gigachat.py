from __future__ import annotations

from app.models import PackagingRequest, PackagingResponse
from app.providers.base import LLMProvider


class GigaChatProvider(LLMProvider):
    @property
    def name(self) -> str:
        return "gigachat"

    @property
    def model(self) -> str:
        return "TODO"

    async def generate_packaging(self, req: PackagingRequest) -> PackagingResponse:
        # TODO(P1,backend): Implement GigaChat API integration.
        # - Obtain token (OAuth/whatever required)
        # - Build prompt template from services/generator.py
        # - Call provider endpoint and parse JSON
        raise NotImplementedError("GigaChatProvider is not implemented yet (TODO).")

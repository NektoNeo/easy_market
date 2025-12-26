
from __future__ import annotations

from abc import ABC, abstractmethod

from app.models import PackagingRequest, PackagingResponse


class LLMProvider(ABC):
    @property
    @abstractmethod
    def name(self) -> str: ...

    @property
    @abstractmethod
    def model(self) -> str: ...

    @abstractmethod
    async def generate_packaging(self, req: PackagingRequest) -> PackagingResponse: ...

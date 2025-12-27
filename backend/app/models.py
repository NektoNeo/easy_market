from __future__ import annotations

from enum import StrEnum
from typing import Literal

from pydantic import BaseModel, ConfigDict, Field


class Marketplace(StrEnum):
    WB = "WB"
    OZON = "OZON"
    AVITO = "AVITO"
    OTHER = "OTHER"


class Tone(StrEnum):
    neutral = "neutral"
    friendly = "friendly"
    premium = "premium"
    strict = "strict"


class RiskSeverity(StrEnum):
    low = "low"
    medium = "medium"
    high = "high"


class Characteristic(BaseModel):
    model_config = ConfigDict(extra="forbid", str_strip_whitespace=True)

    k: str = Field(min_length=1, max_length=80)
    v: str = Field(min_length=1, max_length=120)


class Variant(BaseModel):
    model_config = ConfigDict(extra="forbid", str_strip_whitespace=True)

    name: str = Field(min_length=1, max_length=80)
    value: str = Field(min_length=1, max_length=120)


class OutputOptions(BaseModel):
    """Controls the shape/size of the generated result."""

    model_config = ConfigDict(extra="forbid")

    title_variants: int = Field(default=5, ge=1, le=15)
    bullets_count: int = Field(default=6, ge=0, le=15)
    need_short_description: bool = True
    need_long_description: bool = True
    need_seo: bool = True
    faq_count: int = Field(default=10, ge=0, le=30)
    review_replies_per_sentiment: int = Field(default=3, ge=0, le=10)


class PackagingRequest(BaseModel):
    model_config = ConfigDict(extra="forbid", str_strip_whitespace=True)

    marketplace: Marketplace
    category: str = Field(min_length=1, max_length=120)
    product_name: str = Field(min_length=1, max_length=120)
    brand: str | None = Field(default=None, max_length=80)

    characteristics: list[Characteristic] = Field(default_factory=list, max_length=60)
    variants: list[Variant] = Field(default_factory=list, max_length=30)

    audience: str = Field(min_length=1, max_length=240)
    tone: Tone = Tone.neutral
    forbidden_words: list[str] = Field(default_factory=list, max_length=80)
    forbidden_claims: list[str] = Field(default_factory=list, max_length=40)

    output_options: OutputOptions = Field(default_factory=OutputOptions)

    language: Literal["ru", "en"] = "ru"
    installation_id: str = Field(
        description="UUID from device (used for rate limiting & analytics)",
        min_length=8,
        max_length=64,
    )


class Meta(BaseModel):
    model_config = ConfigDict(extra="forbid")

    request_id: str
    provider: str
    model: str
    latency_ms: int = Field(ge=0)


class RiskFlag(BaseModel):
    model_config = ConfigDict(extra="forbid")

    code: str = Field(min_length=1, max_length=60)
    severity: RiskSeverity
    snippet: str = Field(min_length=1, max_length=200)


class FAQItem(BaseModel):
    model_config = ConfigDict(extra="forbid", str_strip_whitespace=True)

    q: str = Field(min_length=1, max_length=200)
    a: str = Field(min_length=1, max_length=600)


class ReviewReplies(BaseModel):
    model_config = ConfigDict(extra="forbid")

    positive: list[str] = Field(default_factory=list, max_length=20)
    neutral: list[str] = Field(default_factory=list, max_length=20)
    negative: list[str] = Field(default_factory=list, max_length=20)


class Outputs(BaseModel):
    model_config = ConfigDict(extra="forbid")

    titles: list[str] = Field(default_factory=list, max_length=30)
    bullets: list[str] = Field(default_factory=list, max_length=30)
    description_short: str = Field(default="", max_length=2000)
    description_long: str = Field(default="", max_length=6000)
    seo_keywords: list[str] = Field(default_factory=list, max_length=80)
    faq: list[FAQItem] = Field(default_factory=list, max_length=40)
    review_replies: ReviewReplies = Field(default_factory=ReviewReplies)


class PackagingResponse(BaseModel):
    model_config = ConfigDict(extra="forbid")

    meta: Meta
    missing_info_questions: list[str] = Field(default_factory=list, max_length=30)
    risk_flags: list[RiskFlag] = Field(default_factory=list, max_length=30)
    outputs: Outputs
    compliance_notes: list[str] = Field(default_factory=list, max_length=30)


class TemplateDefaults(BaseModel):
    """A tiny subset of settings for quick template presets."""

    model_config = ConfigDict(extra="forbid")

    tone: Tone = Tone.neutral
    faq_count: int = Field(default=8, ge=0, le=30)


class SeedTemplate(BaseModel):
    model_config = ConfigDict(extra="forbid")

    id: str = Field(min_length=1, max_length=40)
    name: str = Field(min_length=1, max_length=60)
    description: str = Field(min_length=1, max_length=200)
    defaults: TemplateDefaults = Field(default_factory=TemplateDefaults)


class TemplatesResponse(BaseModel):
    model_config = ConfigDict(extra="forbid")

    templates: list[SeedTemplate]

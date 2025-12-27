from __future__ import annotations

import re
from dataclasses import dataclass
from time import perf_counter

from app.models import PackagingRequest, PackagingResponse, RiskFlag, RiskSeverity


@dataclass(frozen=True)
class RiskRule:
    code: str
    severity: RiskSeverity
    pattern: re.Pattern[str]


RISK_RULES: list[RiskRule] = [
    RiskRule(
        "MEDICAL_CLAIM",
        RiskSeverity.high,
        re.compile(r"\bлеч(ит|ат|ить|ение)\b", re.I),
    ),
    RiskRule(
        "GUARANTEE",
        RiskSeverity.high,
        re.compile(r"\b(100%|гарант(ир|ия|ируем))\b", re.I),
    ),
    RiskRule(
        "SUPERLATIVE",
        RiskSeverity.medium,
        re.compile(r"\b(лучший|№\s*1|самый)\b", re.I),
    ),
    RiskRule(
        "CERTIFICATION",
        RiskSeverity.medium,
        re.compile(r"\b(сертифицир|gost|гост|роскачество)\b", re.I),
    ),
]


def _iter_text_blocks(resp: PackagingResponse) -> list[str]:
    out: list[str] = []
    o = resp.outputs
    out.extend(o.titles)
    out.extend(o.bullets)
    if o.description_short:
        out.append(o.description_short)
    if o.description_long:
        out.append(o.description_long)
    out.extend(o.seo_keywords)
    for item in o.faq:
        out.append(item.q)
        out.append(item.a)
    out.extend(o.review_replies.positive)
    out.extend(o.review_replies.neutral)
    out.extend(o.review_replies.negative)
    return out


def detect_risks(req: PackagingRequest, resp: PackagingResponse) -> list[RiskFlag]:
    text = "\n".join(_iter_text_blocks(resp))
    flags: list[RiskFlag] = []

    for rule in RISK_RULES:
        m = rule.pattern.search(text)
        if not m:
            continue
        start = max(0, m.start() - 20)
        end = min(len(text), m.end() + 40)
        snippet = text[start:end].strip()
        flags.append(RiskFlag(code=rule.code, severity=rule.severity, snippet=snippet))

    forbidden = [w.strip() for w in req.forbidden_words if w.strip()]
    if forbidden:
        lower_text = text.lower()
        for w in forbidden:
            if w.lower() in lower_text:
                flags.append(
                    RiskFlag(
                        code="FORBIDDEN_WORD",
                        severity=RiskSeverity.high,
                        snippet=f"Обнаружено запрещённое слово: «{w}»",
                    )
                )
                break

    # de-dup by (code,snippet)
    uniq: dict[tuple[str, str], RiskFlag] = {}
    for f in flags:
        uniq[(f.code, f.snippet)] = f
    return list(uniq.values())


def build_prompt(req: PackagingRequest) -> str:
    """
    Prompt builder for real providers (Yandex/GigaChat).

    Mock provider does not use this, but we keep it here because:
    - prompt rules are product-critical
    - easier to test and evolve centrally
    """
    forbidden_words = ", ".join(req.forbidden_words) if req.forbidden_words else "—"
    characteristics = (
        "\n".join([f"- {c.k}: {c.v}" for c in req.characteristics]) or "- (нет данных)"
    )
    variants = "\n".join([f"- {v.name}: {v.value}" for v in req.variants]) or "- (нет вариантов)"

    return f"""
Ты — ассистент для упаковки карточки товара для маркетплейса.
ЖЁСТКИЕ ПРАВИЛА:
1) НИКОГДА не выдумывай факты о товаре. Используй только входные данные.
2) Если данных не хватает — верни список вопросов в missing_info_questions.
3) Верни строго JSON по схеме PackagingResponse. Без markdown, без комментариев.
4) Избегай рискованных обещаний (“лечит”, “100%”, “гарантия результата”,
“лучший/№1”), если это не подтверждено.

ВХОД:
marketplace: {req.marketplace}
category: {req.category}
product_name: {req.product_name}
brand: {req.brand or "-"}
audience: {req.audience}
tone: {req.tone}
forbidden_words: {forbidden_words}

ХАРАКТЕРИСТИКИ:
{characteristics}

ВАРИАНТЫ:
{variants}

OUTPUT_OPTIONS:
{req.output_options.model_dump_json()}

Верни результат в JSON.
""".strip()


async def generate(req: PackagingRequest, provider) -> PackagingResponse:
    """
    Orchestrates generation:
    - calls provider
    - adds risk detection
    - normalizes compliance notes
    """
    t0 = perf_counter()
    resp = await provider.generate_packaging(req)
    _ = perf_counter() - t0

    flags = detect_risks(req, resp)
    notes = list(resp.compliance_notes or [])
    if flags:
        notes.insert(
            0,
            "Обнаружены потенциально рискованные формулировки — проверьте перед публикацией.",
        )

    return resp.model_copy(update={"risk_flags": flags, "compliance_notes": notes})

from __future__ import annotations

import hashlib
import json
import re

from app.models import (
    FAQItem,
    Marketplace,
    Meta,
    Outputs,
    PackagingRequest,
    PackagingResponse,
    ReviewReplies,
)
from app.providers.base import LLMProvider


def _stable_seed(req: PackagingRequest) -> int:
    payload = req.model_dump(mode="json", exclude_none=True)
    raw = json.dumps(payload, ensure_ascii=False, sort_keys=True).encode("utf-8")
    h = hashlib.sha256(raw).hexdigest()
    return int(h[:8], 16)


def _stable_request_id(req: PackagingRequest) -> str:
    payload = req.model_dump(mode="json", exclude_none=True)
    raw = json.dumps(payload, ensure_ascii=False, sort_keys=True).encode("utf-8")
    h = hashlib.sha256(raw).hexdigest()
    return f"req_{h[:12]}"


def _norm(s: str) -> str:
    return s.strip().lower()


def _has_key(req: PackagingRequest, *needles: str) -> bool:
    ks = [_norm(c.k) for c in req.characteristics]
    for k in ks:
        for n in needles:
            if n in k:
                return True
    return False


def _pick_char_values(req: PackagingRequest, limit: int = 3) -> list[str]:
    vals: list[str] = []
    for c in req.characteristics:
        v = c.v.strip()
        if not v:
            continue
        vals.append(v)
        if len(vals) >= limit:
            break
    return vals


def _build_missing_questions(req: PackagingRequest) -> list[str]:
    questions: list[str] = []
    category = _norm(req.category)
    # generic essentials
    if len(req.characteristics) == 0:
        questions.append(
            "Укажите 3–5 ключевых характеристик " "(материал, размер/объём, назначение)."
        )
        questions.append(
            "Уточните, чем товар отличается от аналогов " "(1–2 факта, без рекламных обещаний)."
        )
        return questions

    # category heuristics (simple, safe)
    if any(w in category for w in ["одеж", "куртк", "футбол", "плать", "брюк", "обув"]):
        if not _has_key(req, "размер"):
            questions.append("Какие размеры доступны (например, S–XL или 42–50)?")
        if not _has_key(req, "материал", "состав"):
            questions.append("Какой материал/состав изделия?")
        if not _has_key(req, "цвет"):
            questions.append("Какие цвета доступны?")
    if any(w in category for w in ["крем", "сыворот", "шампун", "космет", "уход"]):
        if not _has_key(req, "объ", "мл", "г", "вес"):
            questions.append("Какой объём/вес (мл/г)?")
        if not _has_key(req, "тип кожи", "кожа"):
            questions.append("Для какого типа кожи/волос предназначено?")
        if not _has_key(req, "состав", "ингредиент"):
            questions.append(
                "Есть ли ключевые ингредиенты/активы, "
                "которые можно упомянуть без обещаний эффекта?"
            )
    if any(w in category for w in ["кабель", "заряд", "электрон", "науш", "ламп", "гаджет"]):
        if not _has_key(req, "совмест", "поддерж", "интерфейс", "разъём", "usb", "type"):
            questions.append("С какими устройствами/интерфейсами совместим товар?")
        if not _has_key(req, "мощ", "ват", "w"):
            questions.append("Какова мощность/параметры питания (если применимо)?")
        if not _has_key(req, "размер", "длин", "габар"):
            questions.append("Какие размеры/длина/габариты (если применимо)?")

    # always ask if audience too generic
    if len(req.audience.strip()) < 8:
        questions.append("Опишите целевую аудиторию чуть подробнее (1–2 предложения).")

    return questions[:10]


def _title_base(req: PackagingRequest) -> str:
    parts = [req.product_name.strip()]
    if req.brand:
        parts.append(req.brand.strip())
    values = _pick_char_values(req, limit=2)
    for v in values:
        parts.append(v)
    return ", ".join([p for p in parts if p])


def _build_titles(req: PackagingRequest, n: int) -> list[str]:
    base = _title_base(req)
    titles: list[str] = []
    # simple marketplace-specific style
    prefix = ""
    if req.marketplace == Marketplace.WB:
        prefix = ""
    elif req.marketplace == Marketplace.OZON:
        prefix = ""
    elif req.marketplace == Marketplace.AVITO:
        prefix = ""
    else:
        prefix = ""

    for i in range(n):
        if i == 0:
            titles.append(prefix + base)
        elif i == 1:
            titles.append(prefix + f"{req.product_name.strip()} — {req.category.strip()}")
        elif i == 2 and req.brand:
            titles.append(prefix + f"{req.brand.strip()} {req.product_name.strip()}")
        else:
            # Reorder characteristics, still only from input
            values = _pick_char_values(req, limit=3)
            if values:
                shift = i % len(values)
                extra = ", ".join(values[shift:] + values[:shift])
            else:
                extra = ""
            if extra:
                titles.append(prefix + f"{req.product_name.strip()}, {extra}")
            else:
                titles.append(prefix + f"{req.product_name.strip()} ({req.category.strip()})")
    # de-dup while preserving order
    seen = set()
    out: list[str] = []
    for t in titles:
        if t not in seen:
            seen.add(t)
            out.append(t)
    return out[:n]


def _build_bullets(req: PackagingRequest, n: int) -> list[str]:
    bullets: list[str] = []
    for c in req.characteristics:
        bullets.append(f"{c.k.strip()}: {c.v.strip()}")
        if len(bullets) >= n:
            return bullets
    return bullets


def _build_descriptions(req: PackagingRequest) -> tuple[str, str]:
    # Only use provided data + safe phrasing.
    characteristics = "; ".join([f"{c.k.strip()}: {c.v.strip()}" for c in req.characteristics[:10]])
    short = f"{req.product_name.strip()} для категории «{req.category.strip()}». "
    if req.brand:
        short += f"Бренд: {req.brand.strip()}. "
    if characteristics:
        short += f"Характеристики: {characteristics}."
    else:
        short += "Характеристики не указаны — добавьте данные для точного описания."
    long = short + "\n\n"
    long += "Кому подойдёт (по вашему описанию): " + req.audience.strip() + ".\n"
    if req.variants:
        variant_items = [f"{v.name.strip()} — {v.value.strip()}" for v in req.variants[:10]]
        long += "Варианты: " + ", ".join(variant_items) + ".\n"
    long += "\nВажно: текст сформирован по введённым данным. Проверьте факты перед публикацией."
    return short.strip(), long.strip()


def _build_seo(req: PackagingRequest, limit: int) -> list[str]:
    # keywords = product_name words + category words + some characteristic values (safe)
    tokens: list[str] = []
    for w in re_split_words(req.product_name):
        tokens.append(w)
    for w in re_split_words(req.category):
        tokens.append(w)
    for c in req.characteristics[:10]:
        tokens.extend(re_split_words(c.v))
    # normalize and unique
    seen = set()
    out: list[str] = []
    for t in tokens:
        t = t.strip().lower()
        if not t or len(t) < 3:
            continue
        if t in seen:
            continue
        seen.add(t)
        out.append(t)
        if len(out) >= limit:
            break
    return out


def re_split_words(s: str) -> list[str]:
    return [w for w in re.split(r"[^\wа-яА-ЯёЁ]+", s) if w]


def _build_faq(req: PackagingRequest, n: int) -> list[FAQItem]:
    faq: list[FAQItem] = []
    # Fill with known facts only
    for c in req.characteristics:
        q = f"Какая характеристика «{c.k.strip()}»?"
        a = c.v.strip()
        faq.append(FAQItem(q=q, a=a))
        if len(faq) >= n:
            return faq

    # If still need more, use audience safely (user-provided)
    if len(faq) < n:
        faq.append(FAQItem(q="Кому подойдёт товар?", a=req.audience.strip()))
    return faq[:n]


def _build_review_replies(req: PackagingRequest, per_sentiment: int) -> ReviewReplies:
    # These are generic, do not require product facts.
    p = [
        "Спасибо за отзыв! Рады, что вам понравилось.",
        "Благодарим за покупку и обратную связь!",
        "Спасибо! Если появятся вопросы — напишите нам.",
    ][:per_sentiment]
    n = [
        "Спасибо за отзыв! Учтём комментарии и постараемся стать лучше.",
        "Благодарим за обратную связь. Если уточните детали — поможем разобраться.",
        "Спасибо! Напишите, что именно можно улучшить — нам важно.",
    ][:per_sentiment]
    neg = [
        "Сожалеем, что возникли неудобства. Напишите, пожалуйста, детали — постараемся помочь.",
        "Спасибо, что сообщили. Уточните, что именно не подошло — предложим решение.",
        "Приносим извинения. Напишите нам, чтобы мы могли разобраться в ситуации.",
    ][:per_sentiment]
    return ReviewReplies(positive=p, neutral=n, negative=neg)


class MockLLMProvider(LLMProvider):
    @property
    def name(self) -> str:
        return "mock"

    @property
    def model(self) -> str:
        return "mock-1"

    async def generate_packaging(self, req: PackagingRequest) -> PackagingResponse:
        # Deterministic request id and latency for stable tests.
        req_id = _stable_request_id(req)
        latency_ms = 42 + (_stable_seed(req) % 20)

        missing = _build_missing_questions(req)

        options = req.output_options
        titles = _build_titles(req, options.title_variants)
        bullets = _build_bullets(req, options.bullets_count)

        desc_short, desc_long = _build_descriptions(req)
        if not options.need_short_description:
            desc_short = ""
        if not options.need_long_description:
            desc_long = ""

        seo = _build_seo(req, limit=30) if options.need_seo else []
        faq = _build_faq(req, options.faq_count) if options.faq_count > 0 else []
        replies = (
            _build_review_replies(req, options.review_replies_per_sentiment)
            if options.review_replies_per_sentiment > 0
            else ReviewReplies()
        )

        outputs = Outputs(
            titles=titles,
            bullets=bullets,
            description_short=desc_short,
            description_long=desc_long,
            seo_keywords=seo,
            faq=faq,
            review_replies=replies,
        )

        compliance_notes = [
            "Проверьте факты перед публикацией (объём, состав, совместимость и т.д.).",
            (
                "Избегайте медицинских и гарантированных обещаний (“лечит”, “100%”, "
                "“гарантия результата”), если это не подтверждено и не разрешено "
                "правилами площадки."
            ),
            "Не используйте сравнения “лучший/№1” без доказательств.",
        ]

        return PackagingResponse(
            meta=Meta(
                request_id=req_id,
                provider=self.name,
                model=self.model,
                latency_ms=latency_ms,
            ),
            missing_info_questions=missing,
            risk_flags=[],
            outputs=outputs,
            compliance_notes=compliance_notes,
        )

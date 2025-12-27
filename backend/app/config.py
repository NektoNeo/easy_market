from __future__ import annotations

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    provider: str = "mock"  # mock|yandex|gigachat
    rate_limit_per_minute: int = 20

    # Provider-specific placeholders
    yandex_api_key: str | None = None
    gigachat_token: str | None = None


settings = Settings(provider=(__import__("os").environ.get("PACKAGER_PROVIDER") or "mock").lower())

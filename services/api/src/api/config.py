from pydantic import BaseModel, Field
from utilityhub_config import load_settings


class AppConfig(BaseModel):
    app_name: str = Field(default="api", description="Service name for logging")


def load_config() -> AppConfig:
    """Load minimal configuration from environment."""
    config, metadata = load_settings(AppConfig, app_name="api")
    return config

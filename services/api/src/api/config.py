from pydantic import BaseModel, Field
from utilityhub_config import load_settings


class AppConfig(BaseModel):
    """Minimal configuration for the API service.

    Per v1 API specification: no build metadata, no runtime metadata,
    no dynamic configuration exposed via API.
    """

    app_name: str = Field(default="gitops-deployment-platform", description="Service name for logging")


def load_config() -> AppConfig:
    """Load minimal configuration from environment."""
    config, metadata = load_settings(AppConfig, app_name="api")
    return config

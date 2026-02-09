"""FastAPI application factory.

Creates a minimal, stateless API service per v1 specification.
"""

import logging
from contextlib import asynccontextmanager

from fastapi import FastAPI

from api import routes
from api.config import AppConfig
from api.error import AppInitializationError

# Set up logging
logger = logging.getLogger(__name__)


def _setup_logging() -> None:
    """Configure basic logging for the service."""
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    )


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application lifespan context manager."""
    # Startup
    logger.info(f"{app.state.config.app_name} starting")
    yield
    # Shutdown
    logger.info(f"{app.state.config.app_name} shutting down")


def create_app(config: AppConfig) -> FastAPI:
    """Create and configure the FastAPI application.

    Per v1 specification:
    - Stateless service
    - No database
    - No persistence
    - Configuration minimal
    """
    try:
        app = FastAPI(
            title="GitOps Deployment Platform API",
            description="Minimal backend for GitOps demonstrations",
            version="1.0.0",
        )

        # Store config in app state (minimal usage)
        app.state.config = config

        # Set up lifespan context
        app.router.lifespan_context = lifespan

        # Include routes
        app.include_router(routes.router)

        return app
    except Exception as e:
        raise AppInitializationError(f"Failed to initialize FastAPI app: {e}") from e

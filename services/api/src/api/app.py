import logging
from contextlib import asynccontextmanager

from fastapi import FastAPI

from api import routes
from api.config import AppConfig
from api.error import AppInitializationError

# Set up logging
logger = logging.getLogger(__name__)


def _setup_logging() -> None:
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    )


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    logger.info(f"{app.state.config.app_name} starting")
    yield
    # Shutdown
    logger.info(f"{app.state.config.app_name} shutting down")


def create_app(config: AppConfig) -> FastAPI:
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

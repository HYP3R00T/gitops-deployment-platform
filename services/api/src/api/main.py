import logging

import uvicorn
from utilityhub_config.errors import ConfigValidationError

from api.app import _setup_logging, create_app
from api.config import load_config
from api.error import APIServiceError, AppInitializationError, ServerStartupError


def main() -> None:
    # Set up logging first
    _setup_logging()
    logger = logging.getLogger(__name__)

    try:
        # Load configuration from environment
        config = load_config()
        logger.info("Configuration loaded successfully")

        # Create FastAPI app
        app = create_app(config)
        logger.info("FastAPI app created")

        # Start uvicorn server
        logger.info("Starting uvicorn server on 0.0.0.0:8000")
        uvicorn.run(
            app,
            host="0.0.0.0",
            port=8000,
            log_config=None,  # Use our logging config
        )
    except ConfigValidationError as e:
        logger.error(f"Configuration error: {e}")
        raise SystemExit(1) from e
    except AppInitializationError as e:
        logger.error(f"Application initialization error: {e}")
        raise SystemExit(1) from e
    except ServerStartupError as e:
        logger.error(f"Server startup error: {e}")
        raise SystemExit(1) from e
    except APIServiceError as e:
        logger.error(f"Service error: {e}")
        raise SystemExit(1) from e
    except Exception as e:
        logger.error(f"Unexpected error: {e}", exc_info=True)
        raise SystemExit(1) from e

"""Custom exceptions for the API service."""


class APIServiceError(Exception):
    """Base exception for all API service errors."""

    pass


class AppInitializationError(APIServiceError):
    """Raised when the FastAPI application fails to initialize."""

    pass


class ServerStartupError(APIServiceError):
    """Raised when the uvicorn server fails to start."""

    pass

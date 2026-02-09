"""API routes implementing v1 specification.

Per spec:
- GET / - Service identity
- GET /health - Health check for Kubernetes probes
- GET /info - Stable metadata for frontend display

All responses are static. No dynamic metadata exposure.
"""

import logging

from fastapi import APIRouter
from fastapi.responses import JSONResponse

router = APIRouter()
logger = logging.getLogger(__name__)


# Health state - simple in-memory flag, resets on restart
_is_healthy = True


@router.get("/")
async def root():
    """Root endpoint - confirms service is running and reachable.

    Response is static per v1 specification.
    """
    return {
        "service": "gitops-deployment-platform",
        "status": "ok",
    }


@router.get("/health")
async def health():
    """Health endpoint for Kubernetes liveness and readiness probes.

    Returns 200 when healthy, non-200 otherwise.
    """
    if _is_healthy:
        return JSONResponse({"healthy": True}, status_code=200)
    else:
        return JSONResponse({"healthy": False}, status_code=503)


@router.get("/info")
async def info():
    """Info endpoint - predictable JSON contract for frontend display.

    Response is static per v1 specification.
    """
    return {
        "name": "gitops-deployment-platform",
        "description": "Minimal backend for GitOps demonstrations",
        "environment": "static",
    }

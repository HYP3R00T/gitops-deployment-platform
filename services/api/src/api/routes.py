import logging

from fastapi import APIRouter
from fastapi.responses import JSONResponse

router = APIRouter()
logger = logging.getLogger(__name__)


# Health state - simple in-memory flag, resets on restart
_is_healthy = True


@router.get("/")
async def root():
    return {
        "service": "gitops-deployment-platform",
        "status": "ok",
    }


@router.get("/health")
async def health():
    if _is_healthy:
        return JSONResponse({"healthy": True}, status_code=200)
    else:
        return JSONResponse({"healthy": False}, status_code=503)


@router.get("/info")
async def info():
    return {
        "name": "gitops-deployment-platform",
        "description": "Minimal backend for GitOps demonstrations",
        "environment": "static",
    }

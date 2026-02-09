"""Tests for v1 API specification."""

import pytest
from api.app import create_app
from api.config import AppConfig
from fastapi.testclient import TestClient


@pytest.fixture
def client():
    """FastAPI test client."""
    config = AppConfig(app_name="api")
    app = create_app(config)
    return TestClient(app)


def test_root(client):
    """GET / returns service identity."""
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {
        "service": "api",
        "status": "ok",
    }


def test_health(client):
    """GET /health returns healthy status."""
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"healthy": True}


def test_info(client):
    """GET /info returns static metadata."""
    response = client.get("/info")
    assert response.status_code == 200
    assert response.json() == {
        "name": "api",
        "description": "Minimal backend for GitOps demonstrations",
        "environment": "static",
    }

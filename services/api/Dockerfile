FROM python:3.14-slim

COPY --from=ghcr.io/astral-sh/uv:0.10.3 /uv /uvx /bin/

ENV PYTHONDONTWRITEBYTECODE=1 \
  PYTHONUNBUFFERED=1

WORKDIR /app

ENV UV_SYSTEM_PYTHON=1

COPY services/api/pyproject.toml ./pyproject.toml

RUN uv pip install -r pyproject.toml

COPY services/api/src ./src

ENV PYTHONPATH=/app/src

EXPOSE 8000

CMD ["python", "-m", "api.main"]

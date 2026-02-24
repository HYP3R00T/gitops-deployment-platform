# https://hub.docker.com/layers/library/python/3.14-alpine
FROM python:3.14-alpine AS build

# Install uv and uvx binaries
COPY --from=ghcr.io/astral-sh/uv:0.10.5 /uv /uvx /bin/

# Keep `WORKDIR` before `ENV` because many environment variables reference paths.
WORKDIR /app

ENV PATH="/app/.venv/bin:$PATH"

# Copy dependency definition (from build context: services/api/)
COPY pyproject.toml ./

# Create virtual environment and install dependencies
RUN uv sync --no-cache --no-dev


## https://hub.docker.com/layers/library/python/3.14-alpine
FROM python:3.14-alpine AS runtime

# Install uv and uvx binaries
COPY --from=ghcr.io/astral-sh/uv:0.10.5 /uv /uvx /bin/

# Create user FIRST (still root here)
RUN addgroup -S app && adduser -S app -G app

# Keep `WORKDIR` before `ENV` because many environment variables reference paths.
WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
  PYTHONUNBUFFERED=1 \
  PYTHONPATH=/app/src \
  PATH="/app/.venv/bin:$PATH" \
  HOST=0.0.0.0 \
  PORT=8000

# Copy only the built artifacts and runtime files
COPY --from=build --chown=app:app /app/.venv /app/.venv
COPY --chown=app:app src/ /app/src/

# NOW drop privilege
USER app

# Run application
CMD ["uv", "run", "-m", "src.main"]

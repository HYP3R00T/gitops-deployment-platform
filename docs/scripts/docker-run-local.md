# docker-run-local.sh

Starts local Docker containers for API and Web services with a shared network bridge.

## Purpose

Sets up a local development environment where both the API and Web services run in Docker containers on the same network, allowing them to communicate with each other and the host machine.

## What It Does

1. **Builds Docker images** from the API and Web service Dockerfiles
2. **Creates a shared Docker network** (`platform-net`) for inter-service communication
3. **Removes any existing containers** with the same names to ensure a clean start
4. **Launches containers**:
   - API service on `localhost:8000` (port 8000 internally)
   - Web service on `localhost:4321` (port 4321 internally)

## Variables

- `NETWORK="platform-net"` — Docker network name for service communication
- `API_IMAGE="platform-api:latest"` — API service Docker image name
- `WEB_IMAGE="platform-web:latest"` — Web service Docker image name

## Usage

```bash
./scripts/docker-run-local.sh
```

After execution, services are available at:

- API: <http://localhost:8000>
- Web: <http://localhost:4321>

## Cleanup

Stop the containers and remove the network:

```bash
./scripts/docker-stop-local.sh
```

## Notes

- Both containers share the `platform-net` network, enabling inter-service communication by hostname
- Existing containers with the same names are removed to avoid port conflicts
- Images are rebuilt from source on each run

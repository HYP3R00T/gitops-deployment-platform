# docker-stop-local.sh

Stops and cleans up local Docker containers and networks created by `docker-run-local.sh`.

## Purpose

Provides a clean way to shut down the local development environment by stopping containers and removing the shared network.

## What It Does

1. **Stops running containers** for API and Web services
2. **Removes the stopped containers** to free up names and resources
3. **Removes the shared Docker network** (`platform-net`)

## Variables

- `NETWORK="platform-net"` — Docker network name to remove (must match `docker-run-local.sh`)

## Usage

```bash
./scripts/docker-stop-local.sh
```

## Related

This script is the cleanup counterpart to `docker-run-local.sh`. Run it when you're done with local development or need to restart with a clean slate.

## Notes

- Safe to run even if containers aren't currently running (uses `|| true` to suppress errors)
- Does not remove images; images are preserved for faster rebuilds

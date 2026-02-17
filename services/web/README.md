# Astro Starter Kit: Basics

```sh
PUBLIC_API_BASE_URL=http://localhost:8000 pnpm --dir services/web dev --host 0.0.0.0
```

## Container image

GHCR image: `ghcr.io/hyp3r00t/gitops-deployment-platform-web`

Example run:

```bash
docker run --rm -p 4321:4321 -e PUBLIC_API_BASE_URL=http://localhost:8000 \
	ghcr.io/hyp3r00t/gitops-deployment-platform-web:<tag>
```

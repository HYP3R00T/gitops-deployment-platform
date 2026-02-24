# https://hub.docker.com/layers/library/node/22.22-bookworm-slim
FROM node:22.22-bookworm-slim AS builder

WORKDIR /app

# Inject API URL at build time (used by Astro build)
ARG PUBLIC_API_URL=http://api:8000

# Enable and pin pnpm version for reproducibility
RUN corepack enable && corepack prepare pnpm@10 --activate

# Install dependencies (cached unless lockfile changes)
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

# Copy source and build production output
COPY . .
ENV PUBLIC_API_URL=${PUBLIC_API_URL}
RUN pnpm run build && pnpm prune --prod


# https://hub.docker.com/layers/library/node/22.22-bookworm-slim
FROM node:22.22-bookworm-slim AS runtime

# Create unprivileged runtime user
RUN groupadd -r app && useradd -r -g app app

WORKDIR /app

# Runtime configuration
ENV NODE_ENV=production \
  PORT=4321 \
  PUBLIC_API_URL=http://api:8000

# Copy only runtime artifacts with correct ownership
COPY --from=builder --chown=app:app /app/dist ./dist
COPY --from=builder --chown=app:app /app/node_modules ./node_modules
COPY --from=builder --chown=app:app /app/package.json ./package.json

USER app

EXPOSE 4321

CMD ["node", "dist/server/entry.mjs"]

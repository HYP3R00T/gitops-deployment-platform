FROM node:20-alpine AS build

ARG PUBLIC_API_URL=http://localhost:8000

WORKDIR /app

COPY services/web/package.json services/web/pnpm-lock.yaml ./

RUN corepack enable && pnpm install --frozen-lockfile

COPY services/web/ ./

ENV PUBLIC_API_URL=${PUBLIC_API_URL}

RUN pnpm build

FROM node:20-alpine

WORKDIR /app

ENV NODE_ENV=production \
  HOST=0.0.0.0 \
  PORT=4321 \
  PUBLIC_API_URL=http://localhost:8000

COPY --from=build /app/dist ./dist
COPY --from=build /app/package.json ./package.json

EXPOSE 4321

CMD ["node", "./dist/server/entry.mjs"]

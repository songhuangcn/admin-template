ARG IMAGE_PROXY="" # 镜像代理，给 CI 用，加快拉取速度
ARG NODE_IMAGE="node:20-slim"
ARG NGINX_IMAGE="nginx:1.22"

FROM ${IMAGE_PROXY}${NODE_IMAGE} AS dev
ARG NPM_MIRROR=""
WORKDIR /app
RUN npm install -g pnpm && \
  if [ -n "$NPM_MIRROR" ]; then \
    pnpm config set registry ${NPM_MIRROR} \
  ; fi && \
  pnpm config set store-dir /pnpm-store
COPY package.json pnpm-lock.yaml ./
COPY pnpm-store /pnpm-store
RUN pnpm install
COPY . .

FROM dev AS builder
RUN pnpm run build

FROM ${IMAGE_PROXY}${NGINX_IMAGE} AS prod
COPY --from=builder /app/dist /app
EXPOSE 443

# Build Node.js Application with esbuild
FROM node:20-alpine AS base

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN corepack enable

WORKDIR /app

# Build tools needed for SST to build the image
RUN apk update && apk add --no-cache \
    g++ \
    make \
    cmake \
    python3 \
    tzdata

# Set build-time argument for the access token
ARG NODE_AUTH_TOKEN

# Create an environment variable to use in the container
ENV NODE_AUTH_TOKEN=${NODE_AUTH_TOKEN}

# Copy files needed to build the app
COPY .npmrc ./.npmrc
COPY package.json pnpm-lock.yaml ./
COPY tsconfig.json build.mjs ./
COPY src ./src

# Install and cache production dependencies (will be copied later)
FROM base AS prod-deps
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --prod --frozen-lockfile
#  --ignore-scripts

# Install all dependencies then build
FROM base AS build
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile
RUN pnpm run build:docker

# Build final runtime image
FROM public.ecr.aws/lambda/nodejs:20

ARG ARCH=x86_64

WORKDIR ${LAMBDA_TASK_ROOT}

# Copy node_modules and dist from earlier stages
COPY --from=prod-deps /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist


# Copy the entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Define environment variables (if any)
ENV NODE_ENV=production
ENV NODE_OPTIONS='--enable-source-maps --stack-trace-limit=1000'
ENV TZ=UTC

# Set the entrypoint for the container
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["dist/lambda.handler"]

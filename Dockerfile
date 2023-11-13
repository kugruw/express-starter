FROM node:alpine as base

FROM base as builder
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . ./
RUN npm run build

FROM base as runner
WORKDIR /usr/src/app
COPY package*.json ./
COPY --from=builder /app/node_modules ./node_modules
RUN npm prune --production
USER node
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/.env ./.env
CMD [ "node", "dist/server.js" ]

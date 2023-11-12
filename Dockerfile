FROM node:alpine as builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . ./
RUN npm run build

FROM node:alpine
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm ci
USER node
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/.env ./.env
CMD [ "node", "dist/server.js" ]

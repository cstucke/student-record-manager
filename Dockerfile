FROM node:22-alpine AS deps

WORKDIR /app

COPY package.json package-lock.json ./

# Native modules such as better-sqlite3 may need a local build on Alpine.
RUN apk add --no-cache python3 make g++ \
  && npm ci --omit=dev

FROM node:22-alpine

WORKDIR /app

ENV NODE_ENV=production

COPY --from=deps /app/node_modules ./node_modules
COPY . .

EXPOSE 3000

CMD ["npm", "start"]

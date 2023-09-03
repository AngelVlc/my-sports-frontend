FROM node:18.17.0-alpine3.17 as base

ARG BACKEND_URL
ARG STRAVA_CLIENT_ID
ARG BUILD_DATE
ENV REACT_APP_BACKEND_URL=${BACKEND_URL}
ENV REACT_APP_STRAVA_CLIENT_ID=${STRAVA_CLIENT_ID}
ENV REACT_APP_BUILD_DATE=${BUILD_DATE}
ENV APP /app
WORKDIR $APP

COPY package.json $APP

RUN npm install

COPY . $APP

RUN npm run-script build

FROM node:18.10.0-alpine3.16 as release

ENV NODE_ENV production
ENV APP /app
WORKDIR $APP

ENV NEXT_TELEMETRY_DISABLED 1

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=base /app/public ./public

# Set the correct permission for prerender cache
RUN mkdir .next
RUN chown nextjs:nodejs .next

# Automatically leverage output traces to reduce image size
# https://nextjs.org/docs/advanced-features/output-file-tracing
COPY --from=base --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=base --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

ENV PORT 3000
# set hostname to localhost
ENV HOSTNAME "0.0.0.0"

CMD ["node", "server.js"]


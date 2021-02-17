# Version of alpine used by base image
ARG ALPINE_VERSION=3.11

FROM elixir:1.11.2-alpine AS build

ARG MIX_ENV
ARG BUILD
ARG SECRET_KEY_BASE

WORKDIR /opt/app

# Install dependencies and build tools
RUN apk update && \
  apk upgrade --no-cache && \
  apk add --no-cache git && \
  mix local.rebar --force && \
  mix local.hex --force

ENV BUILD=${BUILD}
ENV MIX_ENV=${MIX_ENV}
ENV SECRET_KEY_BASE=${SECRET_KEY_BASE}

COPY mix.exs mix.lock start.sh ./
COPY config config

RUN mix do deps.get --only ${MIX_ENV}, deps.compile

COPY priv priv
RUN mix phx.digest

COPY lib lib

RUN mix do compile, release

FROM alpine:3.11 AS app

ARG BUILD
ARG MIX_ENV

RUN apk add --no-cache openssl ncurses-libs

WORKDIR /opt/app

RUN chown nobody:nogroup /opt/app

USER nobody:nogroup

COPY --from=build --chown=nobody:nogroup /opt/app/_build/${MIX_ENV}/rel/xq_archive ./
COPY --from=build --chown=nobody:nogroup /opt/app/start.sh ./

RUN echo "export BUILD=${BUILD} >> .env"

ENV HOME=/opt/app

CMD ["./start.sh"]

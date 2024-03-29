FROM elixir:alpine AS base

RUN apk --no-cache add curl

RUN mkdir -p /home/api/app
WORKDIR /home/api/app

FROM base AS default
RUN adduser -D api

COPY --chown=api:api . /home/api/app
USER api:api

ENV MIX_ENV=prod
RUN ./build.sh

ENTRYPOINT [ "sh", "/home/api/app/run.sh" ]

FROM base AS dev

ENTRYPOINT [ "/bin/sh" ]

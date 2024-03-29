FROM elixir:alpine AS base
RUN adduser -D api

RUN apk --no-cache add curl

RUN mkdir -p /home/api/app && chown -R api:api /home/api/app
WORKDIR /home/api/app


FROM base AS dev

ENTRYPOINT [ "/bin/sh" ]


FROM base AS default

COPY --chown=api:api . /home/api/app
USER api:api

ENV MIX_ENV=prod
RUN ./build.sh

ENTRYPOINT [ "sh", "/home/api/app/run.sh" ]

FROM elixir:alpine

RUN apk --no-cache add curl
RUN adduser -D api

USER api:api

RUN mkdir /home/api/app
WORKDIR /home/api/app
COPY --chown=api:api . /home/api/app

ENV MIX_ENV=prod
RUN ./build.sh

ENTRYPOINT [ "mix", "phx.server" ]

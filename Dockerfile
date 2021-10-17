FROM elixir:alpine

RUN adduser -D api

USER api:api

RUN mkdir /home/api/app
WORKDIR /home/api/app
COPY --chown=api:api . /home/api/app

ENV MIX_ENV=dev

RUN mix local.hex --force
RUN mix deps.get
RUN mix local.rebar --force
RUN mix do compile

ENTRYPOINT [ "mix", "phx.server" ]

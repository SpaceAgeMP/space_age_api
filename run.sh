#!/bin/sh
set -ex
mix do compile
mix ecto.migrate
exec mix phx.server

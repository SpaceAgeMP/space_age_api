#!/bin/sh
set -ex
mix ecto.migrate
exec mix phx.server

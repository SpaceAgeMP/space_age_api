#!/bin/sh
mix ecto.migrate
exec mix phx.server

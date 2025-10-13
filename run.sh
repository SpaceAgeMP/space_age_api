#!/bin/sh
set -ex

export SECRET_KEY_BASE=UoGzGzlE1NoIwH2K/ztS6C2lo+pIsTT0dtbCUJW3A3uQuKMjsNhNRu2buRWNtkMH
export SENTRY_DSN_API=''
export SENTRY_DSN_SRCDS=''

mix ecto.migrate
exec mix phx.server

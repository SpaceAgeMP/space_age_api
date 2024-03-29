#!/bin/sh

set -e

export DATABASE_URL="ecto://USER:PASS@HOST/DATABASE"
export SECRET_KEY_BASE="changeme"
export SENTRY_DSN_SRCDS=""
export SENTRY_DSN_API=""

mix local.hex --force
mix deps.get
mix local.rebar --force
mix do compile

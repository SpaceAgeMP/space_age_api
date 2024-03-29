#!/bin/sh

set -e

mix local.hex --force
mix deps.get
mix local.rebar --force
mix credo --strict

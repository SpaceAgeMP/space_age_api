#!/bin/sh

set -e

./build.sh
mix credo --strict

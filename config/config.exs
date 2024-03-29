# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :space_age_api,
  ecto_repos: [SpaceAgeApi.Repo],
  sentry_dsn_srcds: ""

# Configures the endpoint
config :space_age_api, SpaceAgeApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "UoGzGzlE1NoIwH2K/ztS6C2lo+pIsTT0dtbCUJW3A3uQuKMjsNhNRu2buRWNtkMH",
  render_errors: [view: SpaceAgeApiWeb.ErrorView, accepts: ~w(json)]

config :space_age_api,
  discord_public_key: 91538703886268823595864698159604427502483888689187063955187233768862585484575

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

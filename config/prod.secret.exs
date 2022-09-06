# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

sentry_dsn_srcds = System.get_env("SENTRY_DSN_SRCDS") ||
    raise """
    environment variable SENTRY_DSN_SRCDS is missing.
    """

sentry_dsn_api = System.get_env("SENTRY_DSN_API") ||
    raise """
    environment variable SENTRY_DSN_API is missing.
    """

config :space_age_api, SpaceAgeApi.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :space_age_api, SpaceAgeApiWeb.Endpoint,
  http: [ip: {0,0,0,0}, port: String.to_integer(System.get_env("PORT") || "4000")],
  secret_key_base: secret_key_base

config :joken,
  default_signer: secret_key_base

config :space_age_api,
  sentry_dsn_srcds: sentry_dsn_srcds

config :sentry,
  dsn: sentry_dsn_api

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :space_age_api, SpaceAgeApiWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.

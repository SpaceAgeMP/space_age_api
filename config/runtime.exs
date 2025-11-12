import Config

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
  protocol: :socket,
  socket: System.get_env("MYSQL_SOCKET") || "/var/run/mysqld/mysqld.sock",
  username: System.get_env("MYSQL_USERNAME") || "root",
  password: System.get_env("MYSQL_PASSWORD") || "",
  database: System.get_env("MYSQL_DATABASE") || "spaceage_api",
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

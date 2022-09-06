import Config

# Configure your database
config :space_age_api, SpaceAgeApi.Repo,
  username: "test",
  password: "test",
  database: "space_age_api_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :space_age_api, SpaceAgeApiWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

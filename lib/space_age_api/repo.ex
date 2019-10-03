defmodule SpaceAgeApi.Repo do
  use Ecto.Repo,
    otp_app: :space_age_api,
    adapter: Ecto.Adapters.Postgres
end

defmodule SpaceAgeApi.Repo do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :space_age_api,
    adapter: Ecto.Adapters.MyXQL
end

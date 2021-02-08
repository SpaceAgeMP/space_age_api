defmodule SpaceAgeApi.Models.Application do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "applications" do
    field :faction_name, :string
    field :steamid, :string, primary_key: true
    field :text, :string

    timestamps()
  end

  @doc false
  def changeset(application, attrs) do
    application
    |> cast(attrs, [:steamid, :text, :faction_name])
    |> validate_required([:steamid, :text, :faction_name])
    |> put_change(:updated_at, NaiveDateTime.utc_now)
  end
end

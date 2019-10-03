defmodule SpaceAgeApi.Models.Application do
  use Ecto.Schema
  import Ecto.Changeset

  schema "applications" do
    field :faction_name, :string
    field :steamid, :string
    field :text, :string

    timestamps()
  end

  @doc false
  def changeset(application, attrs) do
    application
    |> cast(attrs, [:steamid, :text, :faction_name])
    |> validate_required([:steamid, :text, :faction_name])
    |> unique_constraint(:steamid)
  end
end

defmodule SpaceAgeApi.Models.Player do
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    field :advancement_level, :integer
    field :alliance_membership_expiry, :integer
    field :credits, :integer
    field :playtime, :integer
    field :faction_name, :string
    field :is_faction_leader, :boolean, default: false
    field :name, :string
    field :research, :map
    field :station_storage, :map
    field :score, :integer
    field :steamid, :string

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name, :steamid, :credits, :score, :is_faction_leader, :alliance_membership_expiry, :faction_name, :advancement_level, :research, :playtime, :station_storage])
    |> validate_required([:name, :steamid, :credits, :score, :is_faction_leader, :alliance_membership_expiry, :faction_name, :advancement_level, :research, :playtime, :station_storage])
    |> unique_constraint(:steamid)
  end
end

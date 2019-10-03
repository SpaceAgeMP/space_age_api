defmodule SpaceAgeApi.Models.Player do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:name, :steamid, :credits, :score, :is_faction_leader, :alliance_membership_expiry, :faction_name, :advancement_level, :research]}
  schema "players" do
    field :advancement_level, :integer
    field :alliance_membership_expiry, :integer
    field :credits, :integer
    field :faction_name, :string
    field :is_faction_leader, :boolean, default: false
    field :name, :string
    field :research, :map
    field :score, :integer
    field :steamid, :string

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name, :steamid, :credits, :score, :is_faction_leader, :alliance_membership_expiry, :faction_name, :advancement_level, :research])
    |> validate_required([:name, :steamid, :credits, :score, :is_faction_leader, :alliance_membership_expiry, :faction_name, :advancement_level, :research])
    |> unique_constraint(:steamid)
  end
end

defmodule SpaceAgeApi.Models.Player do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias SpaceAgeApi.Util

  @primary_key false
  schema "players" do
    field :advancement_level, :integer
    field :alliance_membership_expiry, :integer
    field :credits, :integer
    field :playtime, :integer
    field :faction_name, :string
    field :is_faction_leader, :boolean, default: false
    field :is_donator, :boolean, default: false
    field :name, :string
    field :research, :map
    field :station_storage, :map
    field :score, :integer
    field :steamid, :string, primary_key: true

    timestamps()
  end

  def public_fields() do
    [:steamid, :name, :score, :playtime, :faction_name, :is_faction_leader]
  end

  @doc false
  def changeset(player, attrs) do
    # credo:disable-for-lines:3
    player
    |> cast(attrs, [:name, :steamid, :credits, :score, :is_faction_leader, :is_donator, :alliance_membership_expiry, :faction_name, :advancement_level, :research, :playtime, :station_storage])
    |> validate_required([:name, :steamid, :credits, :score, :is_faction_leader, :is_donator, :alliance_membership_expiry, :faction_name, :advancement_level, :research, :playtime, :station_storage])
    |> put_change(:updated_at, Util.naive_date_time())
  end
end

defmodule SpaceAgeApi.Models.Player do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias SpaceAgeApi.Models.Player
  alias SpaceAgeApi.Repo
  alias SpaceAgeApi.Util

  @primary_key false
  schema "players" do
    field :advancement_level, :integer
    field :credits, :integer
    field :playtime, :integer
    field :faction_name, :string
    field :is_faction_leader, :boolean, default: false
    field :name, :string
    field :research, :map
    field :station_storage, :map
    field :score, :integer
    field :steamid, :string, primary_key: true
    field :group, :string, default: "user"
    field :is_banned, :boolean, default: false
    field :ban_reason, :string
    field :banned_by, :string
    field :discord_user_id, :string

    timestamps()
  end

  def build_query(steamid, select) do
      query = from p in Player,
          where: p.steamid == ^steamid
      if select do
          query
          |> select(^select)
      else
          query
      end
  end

  def get_single(steamid, select \\ nil) do
      Repo.one(build_query(steamid, select))
  end

  def public_fields do
    [:steamid, :name, :score, :playtime, :faction_name, :is_faction_leader]
  end

  @doc false
  def changeset(player, attrs) do
    # credo:disable-for-lines:3
    player
    |> cast(attrs, [:name, :steamid, :credits, :score, :is_faction_leader, :faction_name, :advancement_level, :research, :playtime, :station_storage, :group, :is_banned, :ban_reason, :banned_by, :discord_user_id])
    |> validate_required([:name, :steamid, :credits, :score, :is_faction_leader, :faction_name, :advancement_level, :research, :playtime, :station_storage, :group, :is_banned])
    |> unique_constraint(:discord_user_id)
    |> put_change(:updated_at, Util.naive_date_time())
  end
end

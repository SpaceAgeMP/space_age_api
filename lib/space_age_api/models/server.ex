defmodule SpaceAgeApi.Models.Server do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias SpaceAgeApi.Util

  @primary_key false
  schema "servers" do
    field :authkey, :string
    field :name, :string
    field :map, :string
    field :players, {:array, :string}
    field :maxplayers, :integer
    field :location, :string
    field :ipport, :string
    field :hidden, :boolean

    timestamps()
  end

  def get_link(server) do
    "steam://connect/#{server.ipport}"
  end

  def is_online(server) do
    NaiveDateTime.diff(Util.naive_date_time(), server.updated_at) < 30
  end

  @doc false
  def changeset(server, attrs) do
    server
    |> cast(attrs, [:name, :authkey, :map, :players, :maxplayers, :location, :ipport, :hidden])
    |> validate_required([:name, :authkey, :map, :players, :maxplayers, :location, :ipport, :hidden])
    |> unique_constraint(:name)
    |> unique_constraint(:authkey)
    |> put_change(:updated_at, Util.naive_date_time())
  end
end

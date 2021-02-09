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
    field :players, :integer
    field :maxplayers, :integer
    field :location, :string
    field :hidden, :boolean

    timestamps()
  end

  @doc false
  def changeset(server, attrs) do
    server
    |> cast(attrs, [:name, :authkey, :map, :players, :maxplayers, :location, :hidden])
    |> validate_required([:name, :authkey, :map, :players, :maxplayers, :location, :hidden])
    |> unique_constraint(:name)
    |> unique_constraint(:authkey)
    |> put_change(:updated_at, Util.naive_date_time())
  end
end

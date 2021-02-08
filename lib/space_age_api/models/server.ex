defmodule SpaceAgeApi.Models.Server do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "servers" do
    field :authkey, :string
    field :name, :string
    field :map, :string
    field :players, :integer
    field :maxplayers, :integer
    field :hidden, :boolean

    timestamps()
  end

  @doc false
  def changeset(server, attrs) do
    server
    |> cast(attrs, [:name, :authkey, :map, :players, :maxplayers, :hidden])
    |> validate_required([:name, :authkey, :map, :players, :maxplayers, :hidden])
    |> unique_constraint(:name)
    |> unique_constraint(:authkey)
  end
end

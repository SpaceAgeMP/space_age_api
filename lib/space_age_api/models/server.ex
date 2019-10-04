defmodule SpaceAgeApi.Models.Server do
  use Ecto.Schema
  import Ecto.Changeset

  schema "servers" do
    field :authkey, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(server, attrs) do
    server
    |> cast(attrs, [:name, :authkey])
    |> validate_required([:name, :authkey])
    |> unique_constraint(:name)
    |> unique_constraint(:authkey)
  end
end

defmodule SpaceAgeApi.Models.Goodie do
  use Ecto.Schema
  import Ecto.Changeset

  schema "goodies" do
    field :steamid, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(goodie, attrs) do
    goodie
    |> cast(attrs, [:steamid, :type])
    |> validate_required([:steamid, :type])
  end
end

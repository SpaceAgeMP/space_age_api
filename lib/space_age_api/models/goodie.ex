defmodule SpaceAgeApi.Models.Goodie do
  use Ecto.Schema
  import Ecto.Changeset
  alias SpaceAgeApi.Util

  schema "goodies" do
    field :steamid, :string
    field :type, :string
    field :used, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(goodie, attrs) do
    goodie
    |> cast(attrs, [:steamid, :type, :used])
    |> validate_required([:steamid, :type])
    |> put_change(:updated_at, Util.naive_date_time())
  end
end

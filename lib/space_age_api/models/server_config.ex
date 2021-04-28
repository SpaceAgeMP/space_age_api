defmodule SpaceAgeApi.Models.ServerConfig do
    @moduledoc false
    use Ecto.Schema
    import Ecto.Changeset
    alias SpaceAgeApi.Util
  
    @primary_key false
    schema "server_configs" do
      field :authkey, :string
      field :name, :string
      field :location, :string
      field :hidden, :boolean
      field :rcon_password, :string
      field :steam_account_token, :string
  
      timestamps()
    end
  
    @doc false
    def changeset(server, attrs) do
      server
      |> cast(attrs, [:name, :authkey, :location, :hidden, :rcon_password, :steam_account_token])
      |> validate_required([:name, :authkey, :location, :hidden])
      |> unique_constraint(:name)
      |> unique_constraint(:authkey)
      |> put_change(:updated_at, Util.naive_date_time())
    end
  end
  
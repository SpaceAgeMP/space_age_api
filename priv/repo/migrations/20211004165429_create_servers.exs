defmodule SpaceAgeApi.Repo.Migrations.CreateServers do
  use Ecto.Migration

  def change do
    create table(:servers, primary_key: false) do
      add :name, :string, primary_key: true
      add :map, :string, null: false, default: "sb_gooniverse_v4"
      add :players, :map, null: false
      add :maxplayers, :bigint, null: false, default: 16
      add :ipport, :string, null: false, default: "127.0.0.1:27015"
      add :hidden, :bool, null: false, default: true

      timestamps()
    end
  end
end

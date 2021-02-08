defmodule SpaceAgeApi.Repo.Migrations.CreateServers do
  use Ecto.Migration

  def change do
    create table(:servers) do
      add :name, :string
      add :authkey, :string, primary_key: true
      add :map, :string, null: false, default: "sb_gooniverse_v4"
      add :players, :bigint, null: false, default: 0
      add :maxplayers, :bigint, null: false, default: 16
      add :hidden, :bool, null: false, default: true

      timestamps()
    end

    create unique_index(:servers, [:name])
  end
end

defmodule SpaceAgeApi.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players, primary_key: false) do
      add :name, :string, null: false
      add :steamid, :string, primary_key: true
      add :credits, :bigint, null: false
      add :score, :bigint, null: false
      add :is_faction_leader, :boolean, default: false, null: false
      add :is_donator, :boolean, default: false, null: false
      add :alliance_membership_expiry, :bigint, null: false
      add :faction_name, :string, null: false
      add :advancement_level, :integer, null: false
      add :research, :map, null: false
      add :station_storage, :map, null: false
      add :playtime, :bigint, null: false

      timestamps()
    end

    create index(:players, [:faction_name])
    create index(:players, [:score])
    create index(:players, [:playtime])
  end
end

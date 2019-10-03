defmodule SpaceAgeApi.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :name, :string
      add :steamid, :string
      add :credits, :integer
      add :score, :integer
      add :is_faction_leader, :boolean, default: false, null: false
      add :alliance_membership_expiry, :integer
      add :faction_name, :string
      add :advancement_level, :integer
      add :research, :map

      timestamps()
    end

    create unique_index(:players, [:steamid])
    create index(:players, [:faction_name])
    create index(:players, [:score])
  end
end

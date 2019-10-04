defmodule SpaceAgeApi.Repo.Migrations.CreateApplications do
  use Ecto.Migration

  def change do
    create table(:applications, primary_key: false) do
      add :steamid, :string, primary_key: true
      add :text, :string, null: false
      add :faction_name, :string, null: false

      timestamps()
    end

    create index(:applications, [:faction_name])
  end
end

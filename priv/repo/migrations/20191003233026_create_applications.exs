defmodule SpaceAgeApi.Repo.Migrations.CreateApplications do
  use Ecto.Migration

  def change do
    create table(:applications) do
      add :steamid, :string
      add :text, :string
      add :faction_name, :string

      timestamps()
    end

    create unique_index(:applications, [:steamid])
    create index(:applications, [:faction_name])
  end
end

defmodule SpaceAgeApi.Repo.Migrations.CreateServers do
  use Ecto.Migration

  def change do
    create table(:servers) do
      add :name, :string
      add :authkey, :string

      timestamps()
    end

    create unique_index(:servers, [:name])
    create unique_index(:servers, [:authkey])
  end
end

defmodule SpaceAgeApi.Repo.Migrations.CreateGoodies do
  use Ecto.Migration

  def change do
    create table(:goodies) do
      add :steamid, :string
      add :type, :string

      timestamps()
    end

    create index(:goodies, [:steamid])
  end
end

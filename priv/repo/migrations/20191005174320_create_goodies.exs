defmodule SpaceAgeApi.Repo.Migrations.CreateGoodies do
  use Ecto.Migration

  def change do
    create table(:goodies) do
      add :steamid, :string
      add :type, :string
      add :used, :naive_datetime

      timestamps()
    end

    create index(:goodies, [:steamid])
    create index(:goodies, [:used])
  end
end

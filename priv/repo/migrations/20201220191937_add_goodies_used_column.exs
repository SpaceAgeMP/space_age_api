defmodule SpaceAgeApi.Repo.Migrations.AddGoodiesUsedColumn do
  use Ecto.Migration

  def change do
    alter table (:goodies) do
      add :used, :naive_datetime
    end

    create index(:goodies, [:used])
  end
end

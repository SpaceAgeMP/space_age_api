defmodule SpaceAgeApi.Repo.Migrations.RemoveGoodies do
  use Ecto.Migration

  def change do
    drop table(:goodies)
  end
end

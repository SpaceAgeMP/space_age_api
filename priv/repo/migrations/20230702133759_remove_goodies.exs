defmodule SpaceAgeApi.Repo.Migrations.RemoveGoodies do
  use Ecto.Migration

  def change do
    remove table(:goodie)
  end
end

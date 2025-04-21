defmodule SpaceAgeApi.Repo.Migrations.AddPrestigeLevel do
  use Ecto.Migration

  def change do
    alter table(:players) do
      add :prestige_level, :integer, default: 0, null: false
    end

    create index(:players, [:prestige_level])
  end
end

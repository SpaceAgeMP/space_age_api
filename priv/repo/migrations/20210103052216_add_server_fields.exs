defmodule SpaceAgeApi.Repo.Migrations.AddServerFields do
  use Ecto.Migration

  def change do
    alter table(:servers) do
      add :map, :string, null: false, default: "sb_gooniverse_v4"
      add :players, :bigint, null: false, default: 0
      add :maxplayers, :bigint, null: false, default: 16
      add :hidden, :bool, null: false, default: true
    end
  end
end

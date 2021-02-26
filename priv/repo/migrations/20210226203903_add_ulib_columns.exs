defmodule SpaceAgeApi.Repo.Migrations.AddUlibColumns do
  use Ecto.Migration

  def change do
    alter table(:players) do
      add :group, :string, default: "user", null: false
      add :is_banned, :boolean, default: false, null: false
      add :ban_reason, :longtext, null: true
    end

    create index(:players, [:is_banned])
  end
end

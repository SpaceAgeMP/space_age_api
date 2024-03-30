defmodule SpaceAgeApi.Repo.Migrations.AddDiscordUserId do
  use Ecto.Migration

  def change do
    alter table(:players) do
      add :discord_user_id, :string, default: nil, null: true
    end

    create unique_index(:players, [:discord_user_id])
  end
end

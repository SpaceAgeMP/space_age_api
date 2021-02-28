defmodule SpaceAgeApi.Repo.Migrations.AddServerinfoColumns do
  use Ecto.Migration

  def change do
    alter table(:servers) do
      add :rcon_password, :string, default: "", null: false
      add :steam_account_token, :string, default: "", null: false
    end
  end
end

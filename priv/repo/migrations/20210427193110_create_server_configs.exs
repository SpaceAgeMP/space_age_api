defmodule SpaceAgeApi.Repo.Migrations.CreateServerConfigs do
    use Ecto.Migration
  
    def change do
      create table(:server_configs, primary_key: false) do
        add :name, :string, primary_key: true
        add :authkey, :string
        add :location, :string, null: false, default: "N/A"
        add :rcon_password, :string, default: "", null: false
        add :steam_account_token, :string, default: "", null: false
  
        timestamps()
      end
  
      create unique_index(:server_configs, [:authkey])
    end
  end
  
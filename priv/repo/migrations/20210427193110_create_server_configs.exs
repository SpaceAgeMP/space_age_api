defmodule SpaceAgeApi.Repo.Migrations.CreateServerConfigs do
    use Ecto.Migration
  
    def change do
      create table(:servers) do
        add :name, :string
        add :authkey, :string, primary_key: true
        add :location, :string, null: false, default: "N/A"
        add :hidden, :bool, null: false, default: true
        add :rcon_password, :string, default: "", null: false
        add :steam_account_token, :string, default: "", null: false
  
        timestamps()
      end
  
      create unique_index(:servers, [:name])
    end
  end
  
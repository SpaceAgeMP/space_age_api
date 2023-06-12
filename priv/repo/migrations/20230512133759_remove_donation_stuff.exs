defmodule SpaceAgeApi.Repo.Migrations.AddUlibColumns do
  use Ecto.Migration

  def change do
    alter table(:players) do
      remove :is_donator
      remove :alliance_membership_expiry
    end
  end
end

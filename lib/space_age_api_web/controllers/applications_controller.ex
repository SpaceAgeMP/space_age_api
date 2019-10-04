defmodule SpaceAgeApiWeb.ApplicationsController do
    use SpaceAgeApiWeb, :controller
    import Ecto.Query
    alias SpaceAgeApi.Repo
    alias SpaceAgeApi.Models.Application

    def get_by_player(conn, params) do
        steamid = params["steamid"]
        application = Repo.one(from a in Application,
                                where: a.steamid == ^steamid)

        single_or_404(conn, "single.json", application)
    end

    def upsert_for_player(conn, params) do
        application = Application.changeset(%Application{}, params)
        changeset_perform_upsert_by_steamid(conn, application)
    end

    def list_by_faction(conn, params) do
        faction_name = params["faction_name"]
        applications = Repo.all(from a in Application,
                                where: a.faction_name == ^faction_name)
        render(conn, "multi.json", applications: applications)
    end
end
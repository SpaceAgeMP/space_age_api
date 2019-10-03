defmodule SpaceAgeApiWeb.ApplicationsController do
    use SpaceAgeApiWeb, :controller
    import Ecto.Query
    alias SpaceAgeApi.Repo
    alias SpaceAgeApi.Models.Application

    def get_by_player(conn, params) do
        steamid = params["steamid"]
        application = Repo.one(from a in Application,
                                where: a.steamid == ^steamid)

        if application do
            render(conn, "single.json", application: application)
        else
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(404, "{}")
        end
    end

    def list_by_faction(conn, params) do
        faction_name = params["faction_name"]
        applications = Repo.all(from a in Application,
                                where: a.faction_name == ^faction_name)
        render(conn, "list.json", applications: applications)
    end
end
defmodule SpaceAgeApiWeb.ApplicationsController do
    @moduledoc false
    use SpaceAgeApiWeb, :controller
    import Ecto.Query
    alias SpaceAgeApi.Models.Application
    alias SpaceAgeApi.Models.Player
    alias SpaceAgeApi.Repo

    plug SpaceAgeApi.Plug.Authenticate, [allow_server: true]

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

    def accept_by_faction_for_player(conn, params) do
        faction_name = params["faction_name"]
        steamid = params["steamid"]

        application = Repo.one(from a in Application,
                where: a.steamid == ^steamid and a.faction_name == ^faction_name)

        if application do
            player = Repo.one(from p in Player,
                where: p.steamid == ^steamid)
            changes = Player.changeset(player, %{
                steamid: steamid,
                faction_name: faction_name,
                is_faction_leader: false
            })
            Repo.update!(changes)
            Repo.delete!(application)
        end

        json(conn, %{ok: true})
    end
end

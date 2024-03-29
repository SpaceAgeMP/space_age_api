defmodule SpaceAgeApiWeb.ApplicationsController do
    @moduledoc false
    use SpaceAgeApiWeb, :controller
    import Ecto.Query
    alias SpaceAgeApi.Models.Application
    alias SpaceAgeApi.Models.Player
    alias SpaceAgeApi.Repo

    plug SpaceAgeApi.Plug.Authenticate,
            [allow_server: true, allow_client: true, require_faction_name: true, require_faction_leader: true]
            when action in [:list_by_faction, :decline_by_faction_for_player]
    plug SpaceAgeApi.Plug.Authenticate,
            [allow_server: true, allow_client: true, require_steamid: true]
            when action in [:get_by_player]
    plug SpaceAgeApi.Plug.Authenticate, [allow_server: true] when action in [:upsert, :accept_by_faction_for_player]

    def get_by_player(conn, params) do
        steamid = params["steamid"]
        application = Repo.one(from a in Application,
                                where: a.steamid == ^steamid,
                                join: p in Player, on: p.steamid == a.steamid,
                                select: [a, p])

        single_or_404(conn, "single.json", application)
    end

    def upsert(conn, params) do
        application = Application.changeset(%Application{}, params)
        changeset_perform_upsert_by_steamid(conn, application)
    end

    def list_by_faction(conn, params) do
        faction_name = params["faction_name"]
        applications = Repo.all(from a in Application,
                                where: a.faction_name == ^faction_name,
                                join: p in Player, on: p.steamid == a.steamid,
                                select: [a, p])
        render(conn, "multi.json", applications: applications)
    end

    def decline_by_faction_for_player(conn, params) do
        faction_name = params["faction_name"]
        steamid = params["steamid"]

        application = Repo.one(from a in Application,
                where: a.steamid == ^steamid and a.faction_name == ^faction_name)

        if application do
            Repo.delete!(application)
        end

        json(conn, %{ok: true})
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

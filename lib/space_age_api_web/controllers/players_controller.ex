defmodule SpaceAgeApiWeb.PlayersController do
    @moduledoc false
    use SpaceAgeApiWeb, :controller
    import Ecto.Query
    alias SpaceAgeApi.Models.Player
    alias SpaceAgeApi.Repo
    alias SpaceAgeApi.Util

    plug SpaceAgeApi.Plug.Authenticate, [allow_server: true, allow_client: true, require_steamid: true] when action in [:get_full]
    plug SpaceAgeApi.Plug.Authenticate, [allow_server: true] when action in [:upsert, :ban, :make_jwt]
    plug SpaceAgeApi.Plug.Cache when action in [:list, :get]
    plug SpaceAgeApi.Plug.Cache, [time: 5] when action in [:list_banned]

    def list(conn, _params) do
        render(conn, "multi_public.json", players: Repo.all(from p in Player,
            order_by: [desc: :score],
            select: [:steamid, :name, :score, :playtime, :faction_name, :is_faction_leader],
            where: p.steamid != "STEAM_0:0:0",
            limit: 50))
    end

    def list_banned(conn, _params) do
        render(conn, "multi_banned.json", players: Repo.all(from p in Player,
            select: [:steamid, :name, :is_banned, :ban_reason, :banned_by],
            where: p.is_banned == true,
            limit: 50))
    end

    def get_full(conn, params) do
        get_single_show(conn, params, "single_full.json")
    end

    def get(conn, params) do
        get_single_show(conn, params, "single.json", Player.public_fields)
    end

    def upsert(conn, params) do
        steamid = params["steamid"]
        player_db = get_single(steamid)
        changeset = upsert_changeset(player_db, params)
        changeset_perform_upsert_by_steamid(conn, changeset)
    end

    defp upsert_changeset(nil, params) do
        upsert_changeset(%Player{}, params)
    end
    defp upsert_changeset(player, params) do
        Player.changeset(player, Util.map_decimal_to_integer(params))
    end

    def ban(conn, params) do
        steamid = params["steamid"]
        ban_reason = params["ban_reason"]
        banned_by = params["banned_by"]

        player = get_single(steamid)
        if player do
            changeset = Player.changeset(player, %{
                is_banned: true,
                ban_reason: ban_reason,
                banned_by: banned_by,
            })
            changeset_perform_upsert_by_steamid(conn, changeset)
        else
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(404, "{}")
        end
    end

    def make_jwt(conn, params) do
        steamid = params["steamid"]
        player = get_single(steamid, [:steamid, :faction_name, :is_faction_leader])
        if player do
            make_jwt_internal(conn, player)
        else
            make_jwt_internal(conn, %{
                steamid: steamid,
                faction_name: "freelancer",
                is_faction_leader: false,
            })
        end
    end

    defp get_single_show(conn, params, template, select \\ nil) do
        steamid = params["steamid"]
        player = get_single(steamid, select)
        single_or_404(conn, template, player)
    end

    defp build_query(steamid, select) do
        query = from p in Player,
            where: p.steamid == ^steamid
        if select do
            query
            |> select(^select)
        else
            query
        end
    end

    defp get_single(steamid, select \\ nil) do
        Repo.one(build_query(steamid, select))
    end

    defp make_jwt_internal(conn, player) do
        valid_time = SpaceAgeApi.Token.default_exp()
        expiry = System.system_time(:second) + valid_time

        server = conn.assigns[:auth_server]

        jwt = SpaceAgeApi.Token.generate_and_sign!(%{
            sub: player.steamid,
            server: server.name,
            faction_name: player.faction_name,
            is_faction_leader: player.is_faction_leader,
        })

        single_or_404(conn, "jwt.json", %{
            token: jwt,
            expiry: expiry,
            valid_time: valid_time,
            server: server.name,
            steamid: player.steamid,
            faction_name: player.faction_name,
            is_faction_leader: player.is_faction_leader,
        })
    end
end

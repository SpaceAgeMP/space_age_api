defmodule SpaceAgeApiWeb.PlayersController do
    @moduledoc false
    use SpaceAgeApiWeb, :controller
    import Ecto.Query
    alias SpaceAgeApi.Models.Player
    alias SpaceAgeApi.Repo
    alias SpaceAgeApi.Util

    plug SpaceAgeApi.Plug.Authenticate, [allow_server: true, allow_client: true, require_steamid: true] when action in [:get_full]
    plug SpaceAgeApi.Plug.Authenticate, [allow_server: true] when action in [:upsert, :make_jwt]

    def list(conn, _params) do
        render(conn, "multi_public.json", players: Repo.all(from p in Player,
            order_by: [desc: :score],
            select: [:steamid, :name, :score, :playtime, :faction_name, :is_faction_leader],
            where: p.steamid != "STEAM_0:0:0",
            limit: 50))
    end

    def get_full(conn, params) do
        get_single(conn, params, "single_full.json")
    end

    def get(conn, params) do
        get_single(conn, params, "single.json", [:steamid, :name, :score, :playtime, :faction_name, :is_faction_leader])
    end

    def upsert(conn, params) do
        player = Player.changeset(%Player{}, Util.map_decimal_to_integer(params))
        changeset_perform_upsert_by_steamid(conn, player)
    end

    def make_jwt(conn, params) do
        steamid = params["steamid"]
        valid_time = params["valid_time"]
        player = Repo.one(build_query(steamid, [:steamid, :faction_name, :is_faction_leader]))

        make_jwt_internal(conn, player, valid_time)
    end

    defp make_jwt_internal(conn, player, valid_time) when is_binary(valid_time) do
        make_jwt_internal(conn, player, valid_time |> String.to_integer)
    end

    defp make_jwt_internal(conn, player, valid_time) when valid_time > 0 and valid_time <= 3600 do
        expiry = System.system_time(:second) + valid_time

        jwt = SpaceAgeApi.Token.generate_and_sign!(%{
            exp: expiry,
            sub: player.steamid,
            faction_name: player.faction_name,
            is_faction_leader: player.is_faction_leader,
        })

        single_or_404(conn, "jwt.json", %{
            token: jwt,
            expiry: expiry,
            steamid: player.steamid,
            faction_name: player.faction_name,
            is_faction_leader: player.is_faction_leader,
        })
    end
    defp make_jwt_internal(conn, steamid, _valid_time) do
        make_jwt_internal(conn, steamid, 300)
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

    defp get_single(conn, params, template, select \\ nil) do
        steamid = params["steamid"]
        player = Repo.one(build_query(steamid, select))
        single_or_404(conn, template, player)
    end
end

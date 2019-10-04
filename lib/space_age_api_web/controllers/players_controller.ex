defmodule SpaceAgeApiWeb.PlayersController do
    use SpaceAgeApiWeb, :controller
    import Ecto.Query
    alias SpaceAgeApi.Repo
    alias SpaceAgeApi.Models.Player
    alias SpaceAgeApi.Util

    plug SpaceAgeApi.Plug.Authenticate, [allow_server: true] when action in [:get_full, :upsert]
  
    def list(conn, _params) do
        render(conn, "multi_public.json", players: Repo.all(from Player,
            order_by: [desc: :score],
            select: [:steamid, :name, :score, :playtime],
            limit: 30))
    end

    def get_full(conn, params) do
        get_single(conn, params, "single_full.json")
    end

    def get(conn, params) do
        get_single(conn, params, "single.json", [:steamid, :name, :score, :playtime])
    end

    def upsert(conn, params) do
        player = Player.changeset(%Player{}, Util.map_decimal_to_integer(params))
        changeset_perform_upsert_by_steamid(conn, player)
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
  
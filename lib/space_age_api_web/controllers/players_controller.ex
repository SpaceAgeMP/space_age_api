defmodule SpaceAgeApiWeb.PlayersController do
    use SpaceAgeApiWeb, :controller
    import Ecto.Query
    alias SpaceAgeApi.Repo
    alias SpaceAgeApi.Models.Player
  
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
        get_single(conn, params, "single_public.json", [:steamid, :name, :score, :playtime])
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

        if player do
            render(conn, template, player: player)
        else
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(404, "{}")
        end
    end

    def upsert(conn, params) do
        Repo.insert(struct(Player, params), on_conflict: :replace_all_except_primary_key, conflict_target: :steamid)
        json(conn, %{ok: true})
    end
  end
  
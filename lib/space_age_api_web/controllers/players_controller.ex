defmodule SpaceAgeApiWeb.PlayersController do
    use SpaceAgeApiWeb, :controller
    import Ecto.Query
    alias SpaceAgeApi.Repo
    alias SpaceAgeApi.Models.Player
  
    def list(conn, _params) do
        render(conn, "list.json", players: Repo.all(from Player,
            order_by: [desc: :score],
            select: [:steamid, :name, :score],
            limit: 30))
    end

    def get(conn, params) do
        steamid = params["steamid"]
        render(conn, "get.json", player: Repo.one(from p in Player, where: p.steamid == ^steamid))
    end
  end
  
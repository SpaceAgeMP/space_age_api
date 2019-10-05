defmodule SpaceAgeApiWeb.GoodiesController do
    @moduledoc false
    use SpaceAgeApiWeb, :controller
    import Ecto.Query
    alias SpaceAgeApi.Models.Goodie

    plug SpaceAgeApi.Plug.Authenticate, [allow_server: true, allow_client: true, require_steamid: true] when action in [:list]
    plug SpaceAgeApi.Plug.Authenticate, [allow_server: true] when action in [:delete]

    def list(conn, params) do
        steamid = params["steamid"]

        render(conn, "multi.json",  goodies: Repo.all(from g in Goodie,
            where: g.steamid == ^steamid))
    end

    def delete(conn, params) do
        id = params["id"]
        steamid = params["steamid"]

        goodie = Repo.one(from g in Goodie,
            where: g.id == ^id and g.steamid == ^steamid)
        if goodie do
            Repo.delete(goodie)
            conn
            |> send_resp(204, "")
            |> halt
        else
            conn
            |> send_resp(404, "Not found")
            |> halt
        end
    end
end

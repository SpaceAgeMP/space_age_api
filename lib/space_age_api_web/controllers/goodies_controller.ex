defmodule SpaceAgeApiWeb.GoodiesController do
    @moduledoc false
    use SpaceAgeApiWeb, :controller
    import Ecto.Query
    alias SpaceAgeApi.Models.Goodie

    plug SpaceAgeApi.Plug.Authenticate, [allow_server: true, allow_client: true, require_steamid: true] when action in [:list]
    plug SpaceAgeApi.Plug.Authenticate, [allow_server: true] when action in [:delete, :create]

    def list(conn, params) do
        steamid = params["steamid"]

        render(conn, "multi.json",  goodies: Repo.all(from g in Goodie,
            where: g.steamid == ^steamid and is_nil(g.used)))
    end

    def create(conn, params) do
        goodie = Goodie.changeset(%Goodie{}, params)
        changeset_perform_insert(conn, goodie)
    end

    def delete(conn, params) do
        id = params["id"]
        steamid = params["steamid"]

        goodie = Repo.one(from g in Goodie,
            where: g.id == ^id and g.steamid == ^steamid and is_nil(g.used))
        if goodie do
            changeset = Goodie.changeset(goodie, %{
                used: NaiveDateTime.utc_now(),
            })
            Repo.update!(changeset)

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

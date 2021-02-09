defmodule SpaceAgeApiWeb.ServersController do
    @moduledoc false
    use SpaceAgeApiWeb, :controller
    import Ecto.Query
    alias SpaceAgeApi.Models.Server
    alias SpaceAgeApi.Repo
    alias SpaceAgeApi.Util

    plug SpaceAgeApi.Plug.Authenticate, [allow_server: true] when action in [:get_self, :upsert_self]
    plug SpaceAgeApi.Plug.Cache, [time: 5] when action in [:list, :get]

    def list(conn, _params) do
        render(conn, "multi.json", servers: Repo.all(from s in Server, where: s.hidden == false))
    end

    def get(conn, params) do
        name = params["name"]
        single_or_404(conn, "single.json", Repo.one(from s in Server, where: s.name == ^name))
    end

    def get_self(conn, _params) do
        server = conn.assigns[:auth_server]
        single_or_404(conn, "single.json", server)
    end

    def upsert_self(conn, params) do
        server = Server.changeset(conn.assigns[:auth_server], Util.map_decimal_to_integer(params))
        res = changeset_perform_insert(conn, server, false, on_conflict: {:replace_all_except, [:name, :authkey, :inserted_at]})
        if res do
            single_or_404(conn, "single.json", res)
        end
        conn
    end
end

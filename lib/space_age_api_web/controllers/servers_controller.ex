defmodule SpaceAgeApiWeb.ServersController do
    @moduledoc false
    use SpaceAgeApiWeb, :controller
    import Ecto.Query
    alias SpaceAgeApi.Models.Server
    alias SpaceAgeApi.Repo
    alias SpaceAgeApi.Util

    plug SpaceAgeApi.Plug.Authenticate, [allow_server: true] when action in [:get_self]
    plug SpaceAgeApi.Plug.Cache when action in [:list, :get]

    def list(conn, _params) do
        render(conn, "multi.json", servers: Repo.all(from s in Server))
    end

    def get(conn, params) do
        name = params["name"]
        single_or_404(conn, "single.json", Repo.one(from s in Server, where: s.name == ^name))
    end
end

defmodule SpaceAgeApiWeb.ServersController do
    @moduledoc false
    use SpaceAgeApiWeb, :controller
    import Ecto.Query
    alias SpaceAgeApi.Models.Server
    alias SpaceAgeApi.Models.ServerConfig
    alias SpaceAgeApi.Repo
    alias SpaceAgeApi.Util

    plug SpaceAgeApi.Plug.Authenticate, [allow_server: true] when action in [:get_self_config, :upsert_self]
    plug SpaceAgeApi.Plug.Cache, [time: 5] when action in [:list, :get]

    def list(conn, _params) do
        render(conn, "multi_with_config.json", servers: Repo.all(from s in Server,
            where: s.hidden == false,
            join: c in ServerConfig, on: s.name == c.name,
            select_merge: %{location: c.location}
        ))
    end

    def get(conn, params) do
        name = params["name"]
        single_or_404(conn, "single_with_config.json", Repo.one(from s in Server,
            where: s.name == ^name,
            join: c in ServerConfig, on: s.name == c.name,
            select_merge: %{location: c.location}
        ))
    end

    def get_self_config(conn, _params) do
        server = conn.assigns[:auth_server]
        single_or_404(conn, "single_config.json", server)
    end

    def connect_redirect(conn, params) do
        name = params["name"]
        server = Repo.one(from s in Server, where: s.name == ^name)
        if server != nil and not server.hidden do
            redirect(conn, external: Server.get_link(server))
        else
            conn
            |> put_resp_content_type("text/plain")
            |> send_resp(404, "Server not found")
        end
    end

    def upsert_self(conn, params) do
        server_config = conn.assigns[:auth_server]
        server = Server.changeset(%Server{
            name: server_config.name,
        }, Util.map_decimal_to_integer(params))
        changeset_perform_insert(conn, server, true, on_conflict: {:replace_all_except, [:name, :inserted_at]})
    end
end

defmodule SpaceAgeApiWeb.RabbitMQController do
    @moduledoc false
    use SpaceAgeApiWeb, :controller
    import Ecto.Query
    alias SpaceAgeApi.Models.Server

    plug Plug.Parsers, parsers: [:urlencoded]

    def user(conn, params) do
        username = params["username"]
        password = params["password"]

        server = Repo.one(from s in Server,
            where: s.name == ^username and s.authkey == ^password)
        
        if server do
            conn
            |> send_resp(200, "allow spaceage_server")
            |> halt
        else
            deny(conn)
        end
    end

    def vhost(conn, params) do
        allow_if_spaceage(conn, params)
    end

    def resource(conn, params) do
        allow_if_spaceage(conn, params)
    end

    def topic(conn, params) do
        allow_if_spaceage(conn, params)
    end

    defp allow_if_spaceage(conn, params) do
        vhost = params["vhost"]
        if vhost == "spaceage" do
            allow(conn)
        else
            deny(conn)
        end
    end

    defp allow(conn) do
        conn
        |> send_resp(200, "allow")
        |> halt
    end

    defp deny(conn) do
        conn
        |> send_resp(200, "deny")
        |> halt
    end
end

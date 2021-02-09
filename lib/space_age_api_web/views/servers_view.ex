defmodule SpaceAgeApiWeb.ServersView do
    @moduledoc false
    use SpaceAgeApiWeb, :view

    def render("multi.json", %{servers: servers}) do
        Enum.map(servers, &server_full/1)
    end

    def render("single.json", %{data: server}) do
        server_full(server)
    end

    def server_full(server) do
        if server.hidden do
            %{
                name: server.name,
                map: server.map,
                players: server.players,
                maxplayers: server.maxplayers,
                location: server.location,
                hidden: server.hidden,
                ipport: "127.0.0.1:27015",
                updated_at: server.updated_at,
            }
        else
            %{
                name: server.name,
                map: server.map,
                players: server.players,
                maxplayers: server.maxplayers,
                location: server.location,
                hidden: server.hidden,
                ipport: server.ipport,
                updated_at: server.updated_at,
            }
        end
    end
end

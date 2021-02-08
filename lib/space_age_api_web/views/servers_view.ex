defmodule SpaceAgeApiWeb.PlayersView do
    @moduledoc false
    use SpaceAgeApiWeb, :view

    def render("multi_public.json", %{servers: servers}) do
        Enum.map(servers, &server_full/1)
    end

    def render("single.json", %{data: server}) do
        server_full(server)
    end

    def server_full(server) do
        %{
            name: server.name,
            map: server.map,
            players: server.players,
            maxplayers: server.maxplayers,
            updated_at: server.updated_at,
        }
    end
end

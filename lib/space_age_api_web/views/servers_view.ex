defmodule SpaceAgeApiWeb.ServersView do
    @moduledoc false
    use SpaceAgeApiWeb, :view
    alias SpaceAgeApi.Util

    def render("multi.json", %{servers: servers}) do
        Enum.map(servers, &server_full/1)
    end

    def render("single.json", %{data: server}) do
        server_full(server)
    end

    def server_full(server) do
        online = NaiveDateTime.diff(Util.naive_date_time(), server.updated_at) < 30
        if server.hidden do
            %{
                name: server.name,
                map: server.map,
                players: server.players,
                maxplayers: server.maxplayers,
                location: server.location,
                hidden: server.hidden,
                ipport: "",
                online: online,
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
                online: online,
            }
        end
    end
end

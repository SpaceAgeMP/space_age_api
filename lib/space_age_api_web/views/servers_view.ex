defmodule SpaceAgeApiWeb.ServersView do
    @moduledoc false
    use SpaceAgeApiWeb, :view
    alias SpaceAgeApi.Models.Server
    alias SpaceAgeApi.Models.Player
    alias SpaceAgeApiWeb.PlayersController
    alias SpaceAgeApiWeb.PlayersView

    def render("multi.json", %{servers: servers}) do
        Enum.map(servers, &server_full/1)
    end

    def render("single.json", %{data: server}) do
        server_full(server)
    end

    def server_full(server, do_resolve \\ true) do
        %{
            name: server.name,
            map: server.map,
            players: resolve_players(server.players, do_resolve),
            maxplayers: server.maxplayers,
            location: server.location,
            hidden: server.hidden,
            ipport: server.ipport,
            link: Server.get_link(server),
            online: Server.is_online(server),
        }
    end

    defp resolve_player(steamid) do
        player = PlayersController.get_single(steamid, Player.public_fields)
        PlayersView.player_public(player)
    end

    defp resolve_players(players, true) do
        Enum.map(players, &resolve_player/1)
    end
    defp resolve_players(players, false) do
        players
    end
end

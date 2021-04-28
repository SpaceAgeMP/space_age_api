defmodule SpaceAgeApiWeb.ServersView do
    @sentry_dsn_srcds Application.fetch_env!(:space_age_api, :sentry_dsn_srcds)

    @moduledoc false
    use SpaceAgeApiWeb, :view
    alias SpaceAgeApi.Models.Server
    alias SpaceAgeApi.Models.Player
    alias SpaceAgeApiWeb.PlayersView
    alias SpaceAgeApi.Repo
    import Ecto.Query

    def render("multi_with_config.json", %{servers: servers}) do
        Enum.map(servers, &server_public_with_config/1)
    end

    def render("single_with_config.json", %{data: server}) do
        server_public_with_config(server)
    end

    def render("single.json", %{data: server}) do
        server_public(server)
    end

    def render("single_config.json", %{data: server}) do
        server_config(server)
    end

    def server_public(server, do_resolve \\ true) do
        %{
            name: server.name,
            map: server.map,
            players: resolve_players(server.players, do_resolve),
            maxplayers: server.maxplayers,
            hidden: server.hidden,
            ipport: server.ipport,
            link: Server.get_link(server),
            online: Server.is_online(server),
        }
    end

    def server_public_with_config(server, do_resolve \\ true) do
        %{
            name: server.name,
            map: server.map,
            players: resolve_players(server.players, do_resolve),
            location: server.location,
            maxplayers: server.maxplayers,
            hidden: server.hidden,
            ipport: server.ipport,
            link: Server.get_link(server),
            online: Server.is_online(server),
        }
    end

    def server_config(server) do
        %{
            name: server.name,
            location: server.location,
            rcon_password: server.rcon_password,
            steam_account_token: server.steam_account_token,
            sentry_dsn: @sentry_dsn_srcds,
        }
    end

    defp resolve_players(players, true) do
        fields = Player.public_fields()
        db_players = Repo.all(from p in Player,
            where: p.steamid in ^players,
            select: ^fields)

        Enum.map(db_players, &PlayersView.player_public/1)
    end
    defp resolve_players(players, false) do
        players
    end
end

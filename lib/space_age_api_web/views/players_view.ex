defmodule SpaceAgeApiWeb.PlayersView do
    @moduledoc false
    use SpaceAgeApiWeb, :view

    def render("multi_public.json", %{players: players}) do
        Enum.map(players, &player_public/1)
    end

    def render("single.json", %{data: player}) do
        player_public(player)
    end

    def render("single_full.json", %{data: player}) do
        player_all(player)
    end

    def render("multi_banned.json", %{players: players}) do
        Enum.map(players, &player_banned/1)
    end

    def render("jwt.json", %{data: token}) do
        %{
            token: token.token,
            expiry: token.expiry,
            valid_time: token.valid_time,
            server: token.server,
            steamid: token.steamid,
            faction_name: token.faction_name,
            is_faction_leader: token.is_faction_leader,
        }
    end

    def player_all(player) do
        %{
            advancement_level: player.advancement_level,
            playtime: player.playtime,
            credits: player.credits,
            faction_name: player.faction_name,
            is_faction_leader: player.is_faction_leader,
            station_storage: player.station_storage,
            name: player.name,
            research: player.research,
            score: player.score,
            steamid: player.steamid,
            group: player.group,
            is_banned: player.is_banned,
            ban_reason: player.ban_reason,
            banned_by: player.banned_by,
        }
    end

    def player_banned(player) do
        %{
            name: player.name,
            steamid: player.steamid,
            is_banned: player.is_banned,
            ban_reason: player.ban_reason,
            banned_by: player.banned_by,
        }
    end

    def player_public(player) do
        %{
            name: player.name,
            playtime: player.playtime,
            steamid: player.steamid,
            score: player.score,
            faction_name: player.faction_name,
            is_faction_leader: player.is_faction_leader,
        }
    end
end

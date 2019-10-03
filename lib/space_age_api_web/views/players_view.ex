defmodule SpaceAgeApiWeb.PlayersView do
    use SpaceAgeApiWeb, :view

    def render("multi_public.json", %{players: players}) do
        Enum.map(players, &player_public/1)
    end

    def render("single_public.json", %{player: player}) do
        player_public(player)
    end

    def render("single_full.json", %{player: player}) do
        player_all(player)
    end

    def player_all(player) do
        %{
            advancement_level: player.advancement_level,
            playtime: player.playtime,
            alliance_membership_expiry: player.alliance_membership_expiry,
            credits: player.credits,
            faction_name: player.faction_name,
            is_faction_leader: player.is_faction_leader,
            station_storage: player.station_storage,
            name: player.name,
            research: player.research,
            score: player.score,
            steamid: player.steamid,
        }
    end

    def player_public(player) do
        %{
            name: player.name,
            playtime: player.playtime,
            steamid: player.steamid,
            score: player.score
        }
    end
end

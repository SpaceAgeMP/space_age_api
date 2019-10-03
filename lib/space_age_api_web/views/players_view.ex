defmodule SpaceAgeApiWeb.PlayersView do
    use SpaceAgeApiWeb, :view

    def render("list.json", %{players: players}) do
        Enum.map(players, &player_public/1)
    end

    def render("get.json", %{player: player}) do
        player_all(player)
    end

    def player_all(player) do
        %{
            advancement_level: player.advancement_level,
            alliance_membership_expiry: player.alliance_membership_expiry,
            credits: player.credits,
            faction_name: player.faction_name,
            is_faction_leader: player.is_faction_leader,
            name: player.name,
            research: player.research,
            score: player.score,
            steamid: player.steamid,
        }
    end

    def player_public(player) do
        %{
            name: player.name,
            steamid: player.steamid,
            score: player.score
        }
    end
end

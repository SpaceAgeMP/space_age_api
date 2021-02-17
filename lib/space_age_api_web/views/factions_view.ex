defmodule SpaceAgeApiWeb.FactionsView do
    @moduledoc false
    use SpaceAgeApiWeb, :view
    alias SpaceAgeApiWeb.PlayersView

    def render("multi.json", %{factions: factions}) do
        Enum.map(factions, &faction_all/1)
    end

    def render("members.json", %{members: members}) do
        Enum.map(members, &PlayersView.player_public/1)
    end

    def faction_all(faction) do
        %{
            faction_name: faction.faction_name,
            score: faction.score,
        }
    end
end

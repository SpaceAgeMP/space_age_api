defmodule SpaceAgeApiWeb.FactionsView do
    @moduledoc false
    use SpaceAgeApiWeb, :view

    def render("multi.json", %{factions: factions}) do
        Enum.map(factions, &faction_all/1)
    end

    def faction_all(faction) do
        %{
            faction_name: faction.faction_name,
            credits: faction.credits,
            score: faction.score,
        }
    end
end

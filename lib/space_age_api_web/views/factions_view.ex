defmodule SpaceAgeApiWeb.FactionsView do
    @moduledoc false
    use SpaceAgeApiWeb, :view

    def render("multi_public.json", %{factions: factions}) do
        Enum.map(factions, &faction_public/1)
    end

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

    def faction_public(faction) do
        %{
            faction_name: faction.faction_name,
            score: faction.score,
        }
    end
end

defmodule SpaceAgeApiWeb.ApplicationsView do
    @moduledoc false
    use SpaceAgeApiWeb, :view
    alias SpaceAgeApiWeb.PlayersView

    def render("multi.json", %{applications: applications}) do
        Enum.map(applications, &application_single/1)
    end

    def render("single.json", %{data: application}) do
        application_single(application)
    end

    def application_single([application, player]) do
        %{
            steamid: application.steamid,
            faction_name: application.faction_name,
            text: application.text,
            player: PlayersView.player_public(player),
        }
    end
end

defmodule SpaceAgeApiWeb.ApplicationsView do
    use SpaceAgeApiWeb, :view

    def render("multi.json", %{applications: applications}) do
        Enum.map(applications, &application_single/1)
    end

    def render("single.json", %{data: application}) do
        application_single(application)
    end

    def application_single(application) do
        %{
            steamid: application.steamid,
            faction_name: application.faction_name,
            text: application.text,
        }
    end
end

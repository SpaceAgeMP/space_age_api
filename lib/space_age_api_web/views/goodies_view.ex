defmodule SpaceAgeApiWeb.GoodiesView do
    @moduledoc false
    use SpaceAgeApiWeb, :view

    def render("single.json", %{goodie: goodie}) do
        goodie_all(goodie)
    end

    def render("multi.json", %{goodies: goodies}) do
        Enum.map(goodies, &goodie_all/1)
    end

    def goodie_all(goodie) do
        %{
            id: goodie.id,
            type: goodie.type,
            steamid: goodie.steamid,
        }
    end
end

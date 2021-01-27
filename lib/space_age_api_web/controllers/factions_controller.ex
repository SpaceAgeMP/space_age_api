defmodule SpaceAgeApiWeb.FactionsController do
    @moduledoc false
    use SpaceAgeApiWeb, :controller
    alias SpaceAgeApi.Models.Player
    import Ecto.Query

    plug SpaceAgeApi.Plug.Cache when action in [:list]

    def list(conn, _params) do
        res = Repo.all(from p in Player,
                    group_by: p.faction_name,
                    select: %{faction_name: p.faction_name, credits: sum(p.credits), score: sum(p.score)},
                    where: p.score > 0 and p.steamid != "STEAM_0:0:0" and p.faction_name != "freelancer",
                    order_by: [desc: sum(p.score)])
        render(conn, "multi_public.json", factions: res)
    end
end

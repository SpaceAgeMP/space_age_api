defmodule SpaceAgeApiWeb.FactionsController do
    use SpaceAgeApiWeb, :controller
    alias SpaceAgeApi.Models.Player
    import Ecto.Query

    def list(conn, _params) do
        res = Repo.all(from p in Player,
                    group_by: p.faction_name,
                    select: %{faction_name: p.faction_name, credits: sum(p.credits), score: sum(p.score)},
                    where: p.score > 0,
                    order_by: [desc: sum(p.score)])
        render(conn, "multi_public.json", factions: res)
    end
end

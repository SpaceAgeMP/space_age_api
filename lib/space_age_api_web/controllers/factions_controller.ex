defmodule SpaceAgeApiWeb.FactionsController do
    @moduledoc false
    use SpaceAgeApiWeb, :controller
    alias SpaceAgeApi.Models.Player
    import Ecto.Query

    plug SpaceAgeApi.Plug.Cache when action in [:list]
    plug SpaceAgeApi.Plug.Cache, [time: 5] when action in [:members]

    def list(conn, _params) do
        res = Repo.all(from p in Player,
                    group_by: p.faction_name,
                    select: %{faction_name: p.faction_name, score: fragment("CONVERT(?, SIGNED)", sum(p.score))},
                    where: p.score > 0 and p.steamid != "STEAM_0:0:0" and p.faction_name != "freelancer",
                    order_by: [desc: sum(p.score)])
        render(conn, "multi.json", factions: res)
    end

    def members(conn, params) do
        faction_name = params["faction_name"]
        if faction_name == "freelancer" do
            conn
            |> send_resp(400, "Freelancers cannot be listed")
            |> halt
        else
            fields = Player.public_fields()
            res = Repo.all(from p in Player,
                            select: ^fields,
                            where: p.faction_name == ^faction_name)
            render(conn, "members.json", members: res)
        end
    end
end

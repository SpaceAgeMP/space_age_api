defmodule SpaceAgeApiWeb.HealthController do
    @moduledoc false
    use SpaceAgeApiWeb, :controller

    def check(conn, _params) do
        conn
        |> send_resp(200, "OK")
        |> halt
    end
end

defmodule SpaceAgeApiWeb.GoodiesController do
    @moduledoc false
    use SpaceAgeApiWeb, :controller

    plug SpaceAgeApi.Plug.Authenticate, options: [allow_server: true]

    def list(conn, _params) do
        json(conn, %{})
    end

    def delete(conn, _params) do
        json(conn, %{})
    end
end

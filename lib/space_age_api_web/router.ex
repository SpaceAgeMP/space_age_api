defmodule SpaceAgeApiWeb.Router do
  use SpaceAgeApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/v1", SpaceAgeApiWeb do
    pipe_through :api
    get "/players", PlayersController, :list
    get "/players/:steamid", PlayersController, :get
  end
end

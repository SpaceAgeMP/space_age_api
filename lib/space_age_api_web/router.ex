defmodule SpaceAgeApiWeb.Router do
  use SpaceAgeApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/v1", SpaceAgeApiWeb do
    pipe_through :api
  
    get "/players", PlayersController, :list
    get "/players/:steamid", PlayersController, :get
    get "/players/:steamid/full", PlayersController, :get_full
    put "/players/:steamid", PlayersController, :upsert

    get "/players/:steamid/goodies", GoodiesController, :list
    delete "/players/:steamid/goodies", GoodiesController, :delete

    get "/factions", FactionsController, :list

    get "/players/:steamid/application", ApplicationsController, :get_by_player
    put "/players/:steamid/application", ApplicationsController, :upsert_for_player
    get "/factions/:faction_name/applications", ApplicationsController, :list_by_faction
  end
end

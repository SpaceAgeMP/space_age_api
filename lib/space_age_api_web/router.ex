defmodule SpaceAgeApiWeb.Router do
  @moduledoc false
  use SpaceAgeApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/v2", SpaceAgeApiWeb do
    pipe_through :api

    get "/players", PlayersController, :list
    get "/players/:steamid", PlayersController, :get
    get "/players/:steamid/full", PlayersController, :get_full
    put "/players/:steamid", PlayersController, :upsert
    post "/players/:steamid/jwt", PlayersController, :make_jwt

    get "/players/:steamid/goodies", GoodiesController, :list
    post "/players/:steamid/goodies/:id/use", GoodiesController, :use

    get "/factions", FactionsController, :list
    get "/factions/:faction_name/members", FactionsController, :members

    post "/applications", ApplicationsController, :upsert
    post "/players", PlayersController, :upsert

    get "/players/:steamid/application", ApplicationsController, :get_by_player
    put "/players/:steamid/application", ApplicationsController, :upsert
    get "/factions/:faction_name/applications", ApplicationsController, :list_by_faction
    delete "/factions/:faction_name/applications/:steamid", ApplicationsController, :decline_by_faction_for_player
    post "/factions/:faction_name/applications/:steamid/accept", ApplicationsController, :accept_by_faction_for_player

    get "/servers", ServersController, :list
    get "/servers/self", ServersController, :get_self
    put "/servers/self", ServersController, :upsert_self
    get "/servers/:name", ServersController, :get
    get "/servers/:name/connect", ServersController, :connect_redirect

    post "/rabbitmq/user", RabbitMQController, :user
    post "/rabbitmq/vhost", RabbitMQController, :vhost
    post "/rabbitmq/resource", RabbitMQController, :resource
    post "/rabbitmq/topic", RabbitMQController, :topic
  end
end

defmodule SpaceAgeApiWeb.DiscordView do
  @moduledoc false
  use SpaceAgeApiWeb, :view

  def render("response.json", type, data) do
      %{
          type: type,
          data: data,
      }
  end

  def render("response.json", type) do
      %{
          type: type,
      }
  end
end

defmodule SpaceAgeApiWeb.DiscordView do
  @moduledoc false
  use SpaceAgeApiWeb, :view

  def render("discord.json", %{type: type, data: data}) do
      %{
          type: type,
          data: data,
      }
  end

  def render("discord.json", %{type: type}) do
      %{
          type: type,
      }
  end
end

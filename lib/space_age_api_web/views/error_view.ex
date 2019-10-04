defmodule SpaceAgeApiWeb.ErrorView do
    @moduledoc false
    use SpaceAgeApiWeb, :view

    def render("404.json", _) do
        %{
            ok: false,
            error: "Not found",
        }
    end

    def render("400.json", _) do
        %{
            ok: false,
            error: "Bad request",
        }
    end

    def render("500.json", _) do
        %{
            ok: false,
            error: "Internal server error",
        }
    end
end

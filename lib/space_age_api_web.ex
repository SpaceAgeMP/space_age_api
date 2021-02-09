defmodule SpaceAgeApiWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use SpaceAgeApiWeb, :controller
      use SpaceAgeApiWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: SpaceAgeApiWeb

      import Plug.Conn
      alias SpaceAgeApi.Repo
      alias SpaceAgeApi.Util
      alias SpaceAgeApiWeb.Router.Helpers, as: Routes

      def single_or_404(conn, _template, nil) do
          conn
          |> put_resp_content_type("application/json")
          |> send_resp(404, "{}")
      end

      def single_or_404(conn, template, data) do
          render(conn, template, data: data)
      end

      def changeset_perform_upsert_by_steamid(conn, changeset) do
        changeset_perform_insert(conn, changeset, true, on_conflict: {:replace_all_except, [:steamid, :inserted_at]})
      end

      def changeset_perform_insert(conn, changeset, render \\ true, opts \\ nil) do
        if changeset.valid? do
          Repo.insert!(changeset, opts)
          if render do
            json(conn, %{ok: true})
          end
        else
          conn
          |> put_status(400)
          |> json(%{ok: false, errors: Util.parse_changeset_errors(changeset)})

          false
        end
      end
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/space_age_api_web/views",
        namespace: SpaceAgeApiWeb
        import Plug.Conn
        alias SpaceAgeApiWeb.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end

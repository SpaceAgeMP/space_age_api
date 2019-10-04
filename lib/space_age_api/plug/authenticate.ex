defmodule SpaceAgeApi.Plug.Authenticate do
    import Plug.Conn

    def init(options), do: options
  
    def call(conn, _opts) do
        authHeader = Keyword.get(conn.req_headers, :authorization)
        if authHeader do
            verify_auth_header(conn, authHeader)
        else
            conn
        end
    end

    defp verify_auth_header(conn, auth) do
        [type, token] = String.split(auth, " ", trim: true, parts: 2)
        if type && token do
            verify_auth_header(conn, String.downcase(type), token)
        else
            conn
        end
    end

    defp verify_auth_header(conn, "server", token) do
        conn
        |> assign(:server, true)
        |> assign(:client, false)
    end
    defp verify_auth_header(conn, "client", token) do
        conn
        |> assign(:server, false)
        |> assign(:client, true)
    end
    defp verify_auth_header(conn, _, _) do
        conn
    end
end

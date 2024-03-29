defmodule SpaceAgeApi.Plug.Authenticate do
    @moduledoc """
        Authentication and authorization module for the API
        Accepts auth headers in the following format:
        Server STATIC_TOKEN
        Client JWT
    """
    import Plug.Conn
    import Ecto.Query
    alias SpaceAgeApi.Models.ServerConfig
    alias SpaceAgeApi.Repo

    def init(options), do: options

    def call(conn, opts) do
        conn = parse_auth(conn)
        cond do
            conn.halted -> conn
            opts[:allow_anonymous] -> conn
            opts[:allow_server] && conn.assigns[:auth_server] -> conn
            opts[:allow_client] && conn.assigns[:auth_client] && verify_client_auth(conn, opts) -> conn
            true -> make_conn_unauth(conn)
        end
    end

    defp verify_client_auth(conn, opts) do
        steamid = conn.params["steamid"]
        faction = conn.params["faction_name"]
        auth = conn.assigns[:auth_client]
        cond do
            opts[:require_steamid] && steamid != auth.steamid -> false
            opts[:require_faction_name] && faction != auth.faction_name -> false
            opts[:require_faction_leader] && !auth.is_faction_leader -> false
            true -> true
        end
    end

    defp parse_auth(conn) do
        auth_header = get_req_header(conn, "authorization")
        if auth_header do
            verify_auth_header(conn, auth_header)
        else
            conn
        end
    end

    defp verify_auth_header(conn, []) do
        make_conn_badauth(conn, "none")
    end
    defp verify_auth_header(conn, [auth]) do
        [type, token] = String.split(auth, " ", trim: true, parts: 2)
        if type && token do
            verify_auth_header(conn, String.downcase(type), token)
        else
            make_conn_badauth(conn, "none")
        end
    end

    defp verify_auth_header(conn, "server", token) do
        server = Repo.one(from s in ServerConfig,
                            where: s.authkey == ^token)
        if server do
            conn
            |> set_conn_authid("server #{server.name}")
            |> assign(:auth_server, server)
        else
            make_conn_badauth(conn, "server")
        end
    end
    defp verify_auth_header(conn, "client", token) do
        {ok, claims} = SpaceAgeApi.Token.verify_and_validate(token)
        if ok == :ok and claims["aud"] == "https://api.spaceage.mp/v2/clientauth" do
            steamid = claims["sub"]
            server = claims["server"]
            faction_name = claims["faction_name"]
            is_faction_leader = claims["is_faction_leader"]

            conn
            |> set_conn_authid("client #{steamid} #{server}")
            |> assign(:auth_client, %{
                steamid: steamid,
                server: server,
                faction_name: faction_name,
                is_faction_leader: is_faction_leader,
            })
        else
            make_conn_badauth(conn, "client", claims)
        end
    end
    defp verify_auth_header(conn, type, _token) do
        make_conn_badauth(conn, type)
    end

    defp set_conn_authid(conn, authid) do
        merge_resp_headers(conn, [{"Client-Identity", authid}])
    end
    defp make_conn_badauth(conn, type, reason \\ '') do
        conn
        |> set_conn_authid("#{type} INVALID #{Kernel.inspect(reason)}")
        |> make_conn_unauth
    end
    defp make_conn_unauth(conn) do
        conn
        |> send_resp(401, "Invalid authentication")
        |> halt
    end
end

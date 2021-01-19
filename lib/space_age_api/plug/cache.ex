defmodule SpaceAgeApi.Plug.Cache do
    @moduledoc """
        Adds Cache-Control headers when needed
    """
    import Plug.Conn

    def init(options), do: options

    def call(conn, opts) do
        conn
        |> put_cache_control(opts["time"])
    end

    defp put_cache_control(conn, nil) do
        conn
        |> put_cache_control(300)
    end
    defp put_cache_control(conn, time) do
        conn
        |> put_resp_header("cache-control", "max-age=#{time}")
    end
end

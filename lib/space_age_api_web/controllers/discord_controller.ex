defmodule SpaceAgeApiWeb.DiscordController do
  @moduledoc false
  use SpaceAgeApiWeb, :controller

  def handle_interaction(conn, 1, _data) do
    render(conn, "discord.json", type: 1)
  end

  def handle_interaction(conn, 2, %{
    "member" => %{"user" => %{"id" => user_id}},
    "data" => %{"options" => [
      %{"name" => "operation", "value" => operation},
      ],
      "name" => "sa"
    },
  }) do
    render(conn, "discord.json", type: 2, data: %{
      user_id: user_id,
      operation: operation
    })
  end

  def handle_interaction(conn, 2, _data) do
    conn
    |> send_resp(400, "Unhandled command or invalid parameters")
    |> halt
  end

  def handle_interaction(conn, type, _data) do
    conn
    |> send_resp(400, "Bad type: #{type}")
    |> halt
  end

  def interaction(conn, params) do
      [timestamp | _] = get_req_header(conn, "x-signature-timestamp")
      [signature | _] = get_req_header(conn, "x-signature-ed25519")

      raw_body = SpaceAgeApi.Plug.RawBodyReader.get_raw_body(conn)

      verified = :crypto.verify(
                      :eddsa,
                      :sha256,
                      "#{timestamp}#{raw_body}",
                      Base.decode16!(signature, case: :mixed),
                      [Application.fetch_env!(:space_age_api, :discord_public_key), :ed25519]
                  )

      if verified do
        handle_interaction(conn, params["type"], params)
      else
        conn
        |> send_resp(401, "Unauthorized")
        |> halt
      end
  end
end

defmodule SpaceAgeApiWeb.DiscordController do
  @moduledoc false
  use SpaceAgeApiWeb, :controller

  plug Plug.Parsers,
    parsers: [:json],
    pass: ["*/*"],
    body_reader: {SpaceAgeApi.Plug.RawBodyReader, :read_body, []},
    json_decoder: Phoenix.json_library()

  def handle_interaction(conn, 1, _data) do
    render(conn, "response.json", type: 1)
  end

  def handle_interaction(conn, type, _data) do
    conn
    |> send_resp(400, "Bad type: #{type}")
    |> halt
  end

  def interaction(conn, params) do
      [timestamp | _] = get_req_header(conn, "x-signature-timestamp")
      [signature | _] = get_req_header(conn, "x-signature-ed25519")

      verified = :crypto.verify(
                      :eddsa,
                      :sha256,
                      "#{timestamp}#{conn.assigns[:raw_body]}",
                      Integer.parse(signature, 16),
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

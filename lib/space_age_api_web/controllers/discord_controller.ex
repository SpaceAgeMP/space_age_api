defmodule SpaceAgeApiWeb.DiscordController do
  @moduledoc false
  use SpaceAgeApiWeb, :controller
  alias SpaceAgeApi.Plug.RawBodyReader

  def handle_interaction(conn, 1, _data) do
    render(conn, "discord.json", type: 1)
  end

  def handle_interaction(conn, 2, %{
    "member" => %{"user" => %{"id" => user_id}},
    "data" => %{
      "options" => [
        %{"name" => "operation", "value" => operation},
      ],
      "name" => "sa"
    },
  }) do
    render(conn, "discord.json", type: 4, data: %{
      "content" => "The operation is #{operation} and the user id is #{user_id}"
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

      current_time = System.system_time(:second)
      if abs(current_time - String.to_integer(timestamp)) > 60 do
        conn
        |> send_resp(403, "Timestamp invalid")
        |> halt
      else
        raw_body = RawBodyReader.get_raw_body(conn)

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
end

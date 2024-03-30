defmodule SpaceAgeApiWeb.DiscordController do
  @moduledoc false
  import Ecto.Query

  use SpaceAgeApiWeb, :controller
  alias SpaceAgeApi.Models.Player
  alias SpaceAgeApi.Plug.RawBodyReader

  defp handle_interaction(conn, 1, _data) do
    render(conn, "discord.json", type: 1)
  end

  defp handle_interaction(conn, 2, %{
    "member" => %{"user" => %{"id" => user_id}},
    "data" => %{
      "options" => [
        %{"name" => "code", "value" => code},
      ],
      "name" => "salink"
    },
  }) do
    handle_salink_slash_command(conn, code, "#{user_id}")
  end

  defp handle_interaction(conn, 2, _data) do
    conn
    |> send_resp(400, "Unhandled command or invalid parameters")
    |> halt
  end

  defp handle_interaction(conn, type, _data) do
    conn
    |> send_resp(400, "Bad type: #{type}")
    |> halt
  end

  defp handle_salink_slash_command(conn, "unlink", user_id) do
    query = from p in Player,
      where: p.discord_user_id == ^user_id
    player = Repo.one(query)
    set_player_discord_user_id(conn, player, nil)
    render(conn, "discord.json", type: 4, data: %{
      "content" => "If your Discord account was linked to any Steam account, it has been unlinked.",
      "flags" => 64
    })
  end
  defp handle_salink_slash_command(conn, code, user_id) do
    {ok, claims} = SpaceAgeApi.DiscordLinkToken.verify_and_validate(code)
    if ok == :ok do
      steamid = claims["sub"]
      player = Player.get_single(steamid)
      player_ok = set_player_discord_user_id(conn, player, user_id)
      if player_ok == :ok do
        render(conn, "discord.json", type: 4, data: %{
          "content" => "Your Discord account has successfully been linked to #{steamid}",
          "flags" => 64
        })
      else
        conn
        |> send_resp(500, "Failed to link (not found?!)")
        |> halt
      end
    else
      render(conn, "discord.json", type: 4, data: %{
        "content" => "Your linking token was invalid or expired",
        "flags" => 64
      })
    end
  end

  defp set_player_discord_user_id(_conn, nil, _user_id) do
    :not_found
  end
  defp set_player_discord_user_id(conn, player, user_id) do
    changeset = Player.changeset(player, %{
      discord_user_id: user_id,
    })
    changeset_perform_upsert_by_steamid(conn, changeset, false)
    :ok
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

defmodule SpaceAgeApi.Token do
    @moduledoc """
    Token configuration for SpaceAge API.
    """
    use Joken.Config

    @default_exp 30 * 60

    def default_exp, do: @default_exp

    def token_config do
        default_claims(default_exp: @default_exp, skip: [:aud])
        |> add_claim("aud", nil, &(&1 in [
            "https://api.spaceage.mp/v2/jwt/clientauth",
            "https://api.spaceage.mp/v2/jwt/discordlink"
        ]))
    end
end

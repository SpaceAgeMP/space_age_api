defmodule SpaceAgeApi.Token do
    use Joken.Config
    
    @default_exp 30 * 60

    def default_exp, do: @default_exp

    def token_config, do: default_claims(default_exp: @default_exp)
end
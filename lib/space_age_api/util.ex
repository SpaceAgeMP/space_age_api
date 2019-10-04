defmodule SpaceAgeApi.Util do
    def map_decimal_to_integer(map) do
        for {k, v} <- map, into: %{}, do: {k, decimal_to_integer(v)}
    end

    defp decimal_to_integer(val) when is_float(val) do
        trunc(val)
    end
    defp decimal_to_integer(val) do
        val
    end
end

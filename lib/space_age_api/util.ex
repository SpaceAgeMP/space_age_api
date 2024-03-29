defmodule SpaceAgeApi.Util do
    @moduledoc """
        Utility functions for SpaceAge API
    """
    import Ecto.Changeset

    def map_decimal_to_integer(map) do
        for {k, v} <- map, into: %{}, do: {k, decimal_to_integer(v)}
    end

    defp decimal_to_integer(val) when is_float(val) do
        trunc(val)
    end
    defp decimal_to_integer(val) do
        val
    end

    def parse_changeset_errors(changeset) do
        traverse_errors(changeset, fn {msg, opts} ->
            Enum.reduce(opts, msg, fn {key, value}, acc ->
                String.replace(acc, "%{#{key}}", to_string(value))
            end)
        end)
    end

    def naive_date_time do
        NaiveDateTime.truncate(NaiveDateTime.utc_now, :second)
    end
end

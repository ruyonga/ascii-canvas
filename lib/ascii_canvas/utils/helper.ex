defmodule AsciiCanvas.Utils.Helper do
  @moduledoc false

  def atomize_map_keys(map) do
    Enum.into(map, %{}, &atomize_map_key/1)
  end

  defp atomize_map_key({key, value}) when is_binary(key) do
    value = atomize_nested_map(value)
    {String.to_atom(key), value}
  end

  defp atomize_map_key({key, value}) when is_atom(key) do
    value = atomize_nested_map(value)
    {key, value}
  end

  defp atomize_map_key({key, _value}) do
    raise ArgumentError, "only strings and atoms supported as a key, got: #{inspect(key)}"
  end

  defp atomize_nested_map(%{__struct__: _} = value) do
    value
  end

  defp atomize_nested_map(value) when is_map(value) do
    atomize_map_keys(value)
  end

  defp atomize_nested_map(value) do
    value
  end
end

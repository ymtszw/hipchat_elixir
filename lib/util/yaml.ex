use Croma

defmodule ExHipchat.Yaml do
  @moduledoc """
  YAML to map converter.

  Meant to be used in ex_hipchat.generate mix task.
  Using [ymerl](https://github.com/yakaz/yamerl) inside.
  """

  alias Croma.Result, as: R

  defun from_file(file_name :: Path.t) :: R.t(map) do
    case :yamerl_constr.file(file_name) do
      []                   -> R.pure(%{})                             # Empty file
      [[_ | _] = mappings] -> mappings |> convert_recursive |> R.pure # :yamerl_constr.file/1 only returns single-element list
      error_term           -> {:error, error_term}
    end
  end

  defp convert_recursive([mapping | _] = mappings) when is_tuple(mapping) do # Mappings
    Map.new(mappings, fn {key_name, child} ->
      {String.Chars.to_string(key_name), convert_recursive(child)}
    end)
  end
  defp convert_recursive([h | _t] = chars) when is_integer(h) do # Chars
    String.Chars.to_string(chars)
  end
  defp convert_recursive([_ | _] = non_char_list) do # List of mappings
    Enum.map(non_char_list, &convert_recursive/1)
  end
  defp convert_recursive(boolean) when is_boolean(boolean) do
    boolean
  end
  defp convert_recursive([]) do # Empty top level list (= empty YAML file)
    %{}
  end
end

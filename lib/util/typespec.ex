defmodule Hipchat.Typespec do
  def extract(module) do
    # Credit goes to https://gist.github.com/JEG2/1685a9df2274ca5cf866122fa2dbc42d
    {:ok, {^module, [{:abstract_code, {:raw_abstract_v1, attributes}}]}} =
      module |> :code.which() |> :beam_lib.chunks([:abstract_code])
    user_functions = module.__info__(:functions)
    for {:attribute, _, :spec, {fun_arity, spec}} <- attributes, fun_arity in user_functions do
      {fun_arity, format_spec(spec)}
    end
  end

  defp format_spec(spec_ast) do
    [{:type, _, :fun, [{:type, _, :product, input_type_ast_list}, output_type_ast]}] = spec_ast
    input_types = Enum.map(input_type_ast_list, &type_ast_to_atom/1)
    output_type = type_ast_to_atom(output_type_ast)
    {input_types, output_type}
  end

  defp type_ast_to_atom({:type, _, builtin_type_atom, _}) do
    builtin_type_atom
  end
  defp type_ast_to_atom({:user_type, _, user_type_atom, _}) do
    user_type_atom
  end
  defp type_ast_to_atom({:remote_type, _, module_or_type_atoms}) do
    for {:atom, _, module_or_type_atom} <- module_or_type_atoms do
      module_or_type_atom
    end
  end

  if Mix.env() == :test do
    def generator([String, :t]), do: string()
    def generator([Hipchat.Client, :query_params_t]), do: StreamData.list_of(StreamData.tuple({string(), string()}))
    def generator(:map), do: StreamData.map_of(string(), string())

    defp string(), do: StreamData.string(:printable)
  end
end

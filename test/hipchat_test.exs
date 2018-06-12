defmodule HipchatTest do
  use ExUnit.Case
  use ExUnitProperties
  alias Hipchat.{Typespec, Httpc.Response}

  all_v2_modules =
    :code.lib_dir(:hipchat_elixir, :ebin)
    |> File.ls!()
    |> Enum.filter(&String.starts_with?(&1, "Elixir.Hipchat.V2"))
    |> Enum.map(fn beam_file_name ->
      beam_file_name
      |> String.replace_suffix(".beam", "")
      |> String.to_existing_atom()
    end)

  @dummy_client Hipchat.ApiClient.new("dummy_access_token")

  # Here we are using stream_data just for generating a single random parameter set per API,
  # since overloading HipChat Cloud server with too much requests are not desirable.
  # `@dummy_client` uses a dummy token, so all requests should fail with 401 Unauthorized
  # (provided all APIs require authentication).
  for mod <- all_v2_modules, {{fun, arity}, {[[Hipchat.Client, :t] | other_input_types], _output_type}} <- Typespec.extract(mod) do
    property "#{inspect(mod)}.#{fun}/#{arity} should properly send request" do
      args_generator = unquote(other_input_types) |> Enum.map(fn type -> Typespec.generator(type) end) |> StreamData.fixed_list()
      check all args <- args_generator, max_runs: 1 do
        assert {:ok, %Response{status: 401}} = apply(unquote(mod), unquote(fun), [@dummy_client | args])
      end
    end
  end
end

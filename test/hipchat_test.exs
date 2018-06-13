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

  @token_from_env System.get_env("HIPCHAT_ACCESS_TOKEN")
  @dummy_client   Hipchat.ApiClient.new(@token_from_env || "dummy_access_token", true)

  setup do
    on_exit(fn ->
      Application.put_env(:hipchat_elixir, :serializer, Poison)
    end)
  end

  # Here we are using stream_data just for generating a single random parameter set per API,
  # since overloading HipChat Cloud server with too much requests are not desirable.
  # When `@dummy_client` uses a dummy token, all requests should fail with 401 Unauthorized
  # (provided all APIs require authentication).
  for mod <- all_v2_modules, {{fun, arity}, {[[Hipchat.Client, :t] | other_input_types], _output_type}} <- Typespec.extract(mod) do
    property "#{inspect(mod)}.#{fun}/#{arity} should properly send request" do
      args_generator = unquote(other_input_types) |> Enum.map(fn type -> Typespec.generator(type) end) |> StreamData.fixed_list()
      check all args <- args_generator, not "" in args, max_runs: 1 do
        assert {:ok, %Response{} = res} = apply(unquote(mod), unquote(fun), [@dummy_client | args])
        assert_status(res)
        Application.put_env(:hipchat_elixir, :serializer, :form)
        assert {:ok, %Response{} = res} = apply(unquote(mod), unquote(fun), [@dummy_client | args])
        assert_status(res)
      end
    end
  end

  if @token_from_env do
    defp assert_status(%Response{status: status}) when status in [200, 400, 401, 403, 404, 429], do: :ok
  else
    defp assert_status(%Response{status: 401}), do: :ok
  end
  defp assert_status(res), do: flunk("Unexpected response: #{inspect(res)}")
end

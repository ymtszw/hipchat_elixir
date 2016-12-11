use Croma

defmodule ExHipchat.Httpc do
  alias Croma.Result, as: R

  @moduledoc """
  Thin wrapper around hackney.
  """

  defmodule Method do
    use Croma.SubtypeOfAtom, values: [:get, :post, :put, :delete]
  end

  defmodule Response do
    import Croma.TypeGen, only: [union: 1]
    use Croma.Struct, fields: [
      status:  Croma.NonNegInteger,
      headers: Croma.Map,
      body:    union([Croma.String, Croma.Map]),
    ]
  end

  defmacro __using__(_) do
    quote do
      alias ExHipchat.{Httpc, Method}
      alias ExHipchat.Httpc.Response, as: Res
    end
  end

  @doc """
  Send HTTP request with the given parameters.

  `headers0` is `map` instead of `Keyword.t`, converted in this function.
  `options0` accepts any options available in `:hackney.request/5`.
  Additionally, `:params` option can take query params as `Keyword.t`.
  """
  defun request(method  :: v[Method.t],
                url     :: v[String.t],
                body    :: v[String.t],
                headers :: v[map],
                options :: Keyword.t \\ []) :: R.t(Response.t) do
    url1     = append_params(url, options)
    options1 = [{:with_body, true} | options]
    headers1 = Enum.map(headers, fn {k, v} -> {String.downcase(k), v} end)
    case :hackney.request(method, url1, headers1, body, options1) do
      {:ok, status, resp_headers, resp_body} -> make_response(status, resp_headers, resp_body)
      {:ok, status, resp_headers}            -> make_response(status, resp_headers, "")
      # Won't use stream mode so its branch is omitted
      error_tuple                            -> error_tuple
    end
  end

  defunp append_params(url :: v[String.t], options :: Keyword.t) :: String.t do
    case options[:params] do
      nil    -> url
      params -> url <> "?" <> URI.encode_query(params)
    end
  end

  defunp make_response(status       :: non_neg_integer,
                       resp_headers :: Keyword.t,
                       resp_body    :: String.t) :: R.t(Response.t) do
    (status, resp_headers, ""       ) -> Response.new(%{status: status, headers: convert_resp_headers(resp_headers), body: ""})
    (status, resp_headers, resp_body) ->
      resp_headers1 = convert_resp_headers(resp_headers)
      convert_resp_body(resp_headers1, resp_body)
      |> R.bind(fn converted_body ->
        Response.new(%{status: status, headers: resp_headers1, body: converted_body})
      end)
  end

  defunp convert_resp_headers(resp_headers :: Keyword.t) :: map do
    Map.new(resp_headers, fn {key, value} ->
      {String.downcase(key), value}
    end)
  end

  defunp convert_resp_body(downcased_resp_headers :: map, resp_body :: String.t) :: R.t(String.t | map) do
    (%{"content-type" => "application/json"}, resp_body) -> Poison.decode(resp_body)
    (_not_json                              , resp_body) -> {:ok, resp_body}
  end
end

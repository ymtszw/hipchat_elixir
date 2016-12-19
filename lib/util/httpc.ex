defmodule Hipchat.Httpc do
  @moduledoc """
  Thin wrapper around hackney.
  """

  defmodule Method do
    @moduledoc """
    Available HTTP methods in `Httpc`.
    """

    @type t :: :get | :post | :put | :delete
  end

  defmodule Response do
    @moduledoc """
    Struct module for response of `Httpc.request/5`.
    """

    defstruct [:status, :headers, :body]
    @type t :: %__MODULE__{
      status:  non_neg_integer,
      headers: map,
      body:    binary | map,
    }

    @spec new(non_neg_integer, map, binary | map) :: {:ok, t} | {:error, tuple}
    def new(status, headers, body) when status > 99 and status < 600 and is_map(headers) and (is_binary(body) or is_map(body)) do # XXX
      {:ok, %__MODULE__{
        status:  status,
        headers: headers,
        body:    body,
      }}
    end
    def new(status, headers, body) do
      {:error, {:invalid_args, status, headers, body}}
    end
  end

  defmacro __using__(_) do
    quote do
      alias Hipchat.{Httpc, Method}
      alias Hipchat.Httpc.Response, as: Res
    end
  end

  @doc """
  Send HTTP request with the given parameters.

  `headers0` is `map` instead of `Keyword.t`, converted in this function.
  `options0` accepts any options available in `:hackney.request/5`.
  Additionally, `:params` option can take query params as `[{String.t, String.t}]`.
  """
  @spec request(Method.t, String.t, binary, %{String.t => String.t}, Keyword.t) :: {:ok, Response.t} | {:error, term}
  def request(method, url, body, headers, options \\ []) do
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

  defp append_params(url, options) do
    case options[:params] do
      [_ | _] = params -> url <> "?" <> URI.encode_query(params)
      _empty_or_nil    -> url
    end
  end

  @spec make_response(non_neg_integer, [{binary, binary}], binary) :: {:ok, Response.t} | {:error, term}
  defp make_response(status, resp_headers, "") do
    Response.new(status, convert_resp_headers(resp_headers), "")
  end
  defp make_response(status, resp_headers0, resp_body) do
    resp_headers1 = convert_resp_headers(resp_headers0)
    case convert_resp_body(resp_headers1, resp_body) do
      {:ok, converted_body} -> Response.new(status, resp_headers1, converted_body)
      error_tuple           -> error_tuple
    end
  end

  defp convert_resp_headers(resp_headers) do
    Map.new(resp_headers, fn {key, value} ->
      {String.downcase(key), value}
    end)
  end

  @spec convert_resp_body(map, String.t) :: {:ok, String.t | map} | {:error, term}
  defp convert_resp_body(%{"content-type" => "application/json"}, resp_body), do: Poison.decode(resp_body)
  defp convert_resp_body(_not_json                              , resp_body), do: {:ok, resp_body}
end

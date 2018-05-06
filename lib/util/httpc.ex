defmodule Hipchat.Httpc do
  @moduledoc """
  Thin wrapper around hackney. Used in all API functions.
  """

  defmodule Response do
    @moduledoc """
    Struct module for response of `Httpc.request/5`.

    All keys in `headers` are downcased.
    If `body` is not empty, it should be a JSON string.
    """

    defstruct [:status, :headers, :body]
    @type t :: %__MODULE__{
      status:  non_neg_integer,
      headers: map,
      body:    binary,
    }

    @spec new(non_neg_integer, map, binary | map) :: {:ok, t} | {:error, tuple}
    def new(status, headers, body) when status > 99 and status < 600 and is_map(headers) and is_binary(body) do
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

  @type method_t  :: :get | :post | :put | :delete
  @type headers_t :: [{String.t, String.t}]
  @type options_t :: list
  @type res_t     :: {:ok, Response.t} | {:error, term}

  @doc """
  Send HTTP request with the given parameters.

  `options` accepts any options available in `:hackney.request/5`.
  Additionally, `:params` option can take query params as `Hipchat.Client.query_params_t`.
  """
  @spec request(method_t, String.t, term, headers_t, options_t) :: res_t
  def request(method, url, body, headers, options \\ []) do
    url1              = append_params(url, options)
    options1          = [{:with_body, true} | options]
    {body1, headers1} = serialize_body(body, headers)
    case :hackney.request(method, url1, headers1, body1, options1) do
      {:ok, status, resp_headers, resp_body} -> Response.new(status, convert_resp_headers(resp_headers), resp_body)
      {:ok, status, resp_headers}            -> Response.new(status, convert_resp_headers(resp_headers), "")
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

  @serializer Application.get_env(:hipchat_elixir, :serializer, Poison)
  case Code.ensure_loaded(@serializer) do
    {:module, Poison} ->
      defp serialize_body(body, headers), do: {Poison.encode!(body), [{"content-type", "application/json"} | headers]}
    {:error, _} ->
      defp serialize_body(body, headers), do: {{:form, Map.to_list(body)}, headers}
  end

  defp convert_resp_headers(resp_headers) do
    Map.new(resp_headers, fn {key, value} ->
      {String.downcase(key), value}
    end)
  end
end

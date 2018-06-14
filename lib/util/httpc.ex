defmodule Hipchat.Httpc do
  @moduledoc """
  Thin wrapper around Erlang's `httpc`. Used in all API functions.
  """

  defmodule Response do
    @moduledoc """
    Struct module for response of `Httpc.request/5`.

    All keys in `headers` are downcased.
    If `body` is not empty, it should be a JSON string.
    """

    defstruct [:status, :headers, :body, :request]
    @type t :: %__MODULE__{
      status:  non_neg_integer,
      headers: map,
      body:    binary,
      request: map,
    }

    @spec new(non_neg_integer, map, binary | map, map) :: {:ok, t} | {:error, tuple}
    def new(status, headers, body, request) when status > 99 and status < 600 and is_map(headers) and is_binary(body) do
      {:ok, %__MODULE__{
        status:  status,
        headers: headers,
        body:    body,
        request: request,
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

  `options` accepts any options available in `:httpc.request/4`. Additionally,

  - `:http_options` for `http_options` in `:httpc.request/4`
  - `:params` option can take query params as `Hipchat.Client.query_params_t`.

  It can be injected via `Hipchat.Client.t`.
  """
  @spec request(method_t, String.t, term, headers_t, options_t) :: res_t
  def request(method, url, body, headers, options \\ []) do
    url1          = url_with_params(url, options)
    {body1, type} = serialize_body(body)
    httpc_req     = httpc_req(url1, headers, type, body1)
    request_dump  = %{method: method, httpc_req: httpc_req}
    case :httpc.request(method, httpc_req, Keyword.get(options, :http_options, []), force_sync_options(options)) do
      {:ok, {{_http_ver, status, _reason}, resp_headers, resp_body}} ->
        Response.new(status, charlist_kvs_to_map(resp_headers), resp_body, request_dump)
      {:error, _} = error_tuple ->
        error_tuple
    end
  end

  defp url_with_params(url, options) do
    case options[:params] do
      [_ | _] = params -> URI.encode(url) <> "?" <> URI.encode_query(params)
      _empty_or_nil    -> URI.encode(url)
    end
  end

  defp serialize_body("") do
    {nil, nil}
  end
  defp serialize_body(body) do
    case serializer() do
      Poison ->
        {Poison.encode!(body), 'application/json'}
      :form ->
        {URI.encode_query(body), 'application/x-www-form-urlencoded'}
    end
  end

  defp serializer() do
    Application.get_env(:hipchat_elixir, :serializer, Poison)
  end

  defp httpc_req(url_with_param, headers, nil, nil) do
    {binary_to_charlist(url_with_param), to_charlist_kvs(headers)}
  end
  defp httpc_req(url_with_param, headers, content_type, body) do
    {binary_to_charlist(url_with_param), to_charlist_kvs(headers), content_type, body}
  end

  defp force_sync_options(options) do
    options
    |> Keyword.delete(:params)
    |> Keyword.merge([
      sync: true,
      body_format: :binary,
      full_result: true,
    ])
    |> to_charlist_kvs()
  end

  defp binary_to_charlist(binary) when is_binary(binary), do: to_charlist(binary)
  defp binary_to_charlist(other), do: other

  defp to_charlist_kvs(kvs) do
    Enum.map(kvs, fn {key, val} -> {binary_to_charlist(key), binary_to_charlist(val)} end)
  end

  defp charlist_kvs_to_map(kvs) do
    Map.new(kvs, fn {key, val} -> {List.to_string(key), List.to_string(val)} end)
  end
end

defprotocol Hipchat.Client do
  @moduledoc """
  Client protocol used by `ApiClient` and `OauthClient`.
  """
  @fallback_to_any true

  @type t :: Hipchat.ApiClient.t | Hipchat.OauthClient.t
  @type query_params_t :: [{String.t, String.t}]

  @doc """
  Produces headers for `Hipchat.Httpc.request/5`.
  """
  @spec headers(t) :: Hipchat.Httpc.headers_t
  def headers(client)

  @doc """
  Produces options for `Hipchat.Httpc.request/5`
  """
  @spec options(t, query_params_t) :: Hipchat.Httpc.options_t
  def options(client, query_params)
end

defimpl Hipchat.Client, for: Any do
  @err "Hipchat.Client protocol is only valid for select struct types."
  def headers(_), do: raise(@err)
  def options(_, _), do: raise(@err)
end

defmodule Hipchat.ApiClient do
  @moduledoc """
  Client struct module for ordinary HipChat APIs.

  Here, by "ordinary" it refers to APIs that require authentication with any type of `access_token`,
  or APIs that do not require authentication at all (such as Capabilities API).

  If you need to make a OAuth token retrieval request to fetch `access_token`s,
  use `Hipchat.OauthClient` instead.
  """

  defstruct [:access_token, :auth_test?, :httpc_opts]
  @type t :: %__MODULE__{
    access_token: nil | String.t,
    auth_test?:   boolean,
    httpc_opts:   list,
  }

  @doc """
  Generate `ApiClient` struct.

  `access_token` needs to be retrieved beforehand. It will be included in an Authorization header.
  If set to `nil` the header will not be generated.

  If `auth_test?` is set to `true`, `auth_test=true` query parameter will be generated. Defaults to `false`.
  This can be used to test an `access_token`.

  For `httpc_opts`, see `Hipchat.Httpc.request/5` for details.
  """
  @spec new(nil | String.t, boolean, list) :: t
  def new(access_token, auth_test? \\ false, httpc_opts \\ []) do
    %__MODULE__{
      access_token: access_token,
      auth_test?:   auth_test?,
      httpc_opts:   httpc_opts,
    }
  end

  alias __MODULE__, as: AC
  defimpl Hipchat.Client do
    def headers(%AC{access_token: nil}), do: []
    def headers(%AC{access_token: a_t}), do: [{"authorization", "Bearer #{a_t}"}]

    def options(%AC{auth_test?: false, httpc_opts: ho}, query_params), do: [{:params, query_params} | ho]
    def options(%AC{auth_test?: true , httpc_opts: ho}, query_params), do: [{:params, [{"auth_test", "true"} | query_params]} | ho]
  end
end

defmodule Hipchat.OauthClient do
  @moduledoc """
  Client struct module for OAuth Token API.

  Use this client and request to Token API (e.g. `Hipchat.V2.Oauth.generate_token/2`)
  to retrieve Add-on token or User token.
  """
  defstruct [:client_id, :client_secret, :httpc_opts]
  @type t :: %__MODULE__{
    client_id:     String.t,
    client_secret: String.t,
    httpc_opts:    list,
  }

  @doc """
  Generate `OauthClient` struct.

  `client_id` and `client_secret` must be retrieved and stored on Add-on server per installation,
  during [Add-on Installation Flow](https://developer.atlassian.com/hipchat/guide/installation-flow).

  For `httpc_opts`, see `Hipchat.Httpc.request/5` for details.
  """
  @spec new(String.t, String.t, list) :: t
  def new(client_id, client_secret, httpc_opts \\ []) do
    %__MODULE__{
      client_id:     client_id,
      client_secret: client_secret,
      httpc_opts:    httpc_opts,
    }
  end

  alias __MODULE__, as: OC
  defimpl Hipchat.Client do
    def headers(%OC{client_id: ci, client_secret: cs}) do
      encoded = Base.encode64("#{ci}:#{cs}")
      [{"authorization", "Basic #{encoded}"}]
    end

    def options(%OC{httpc_opts: ho}, query_params), do: [{:params, query_params} | ho]
  end
end

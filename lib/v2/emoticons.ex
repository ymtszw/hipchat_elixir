# Code generated by `$ mix hipchat.generate`
defmodule Hipchat.V2.Emoticons do
  @moduledoc """
  HipChat V2 Emoticons API module.
  """

  alias Hipchat.{Client, Httpc}

  @endpoint "https://api.hipchat.com/v2"

  @doc """
  [https://www.hipchat.com/docs/apiv2/method/get_all_emoticons](https://www.hipchat.com/docs/apiv2/method/get_all_emoticons)
  """
  @spec get_all_emoticons(Client.t, Client.query_params_t) :: Httpc.res_t
  def get_all_emoticons(client, query_params) do
    Httpc.request(:get,
                  "#{@endpoint}/emoticon",
                  "",
                  Client.headers(client),
                  Client.options(client, query_params))
  end

  @doc """
  [https://www.hipchat.com/docs/apiv2/method/get_emoticon](https://www.hipchat.com/docs/apiv2/method/get_emoticon)
  """
  @spec get_emoticon(Client.t, String.t) :: Httpc.res_t
  def get_emoticon(client, emoticon_id_or_key) do
    Httpc.request(:get,
                  "#{@endpoint}/emoticon/#{emoticon_id_or_key}",
                  "",
                  Client.headers(client),
                  Client.options(client, []))
  end
end
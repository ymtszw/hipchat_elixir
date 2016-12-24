# Code generated by `$ mix hipchat.generate`
defmodule Hipchat.V2.Groups do
  @moduledoc """
  HipChat V2 Groups API module.
  """

  alias Hipchat.{Client, Httpc}

  @endpoint "https://api.hipchat.com/v2"

  @doc """
  [https://www.hipchat.com/docs/apiv2/method/delete_group_avatar](https://www.hipchat.com/docs/apiv2/method/delete_group_avatar)
  """
  @spec delete_group_avatar(Client.t, String.t) :: Httpc.res_t
  def delete_group_avatar(client, group_id) do
    Httpc.request(:delete,
                  "#{@endpoint}/group/#{group_id}/avatar",
                  "",
                  Client.headers(client),
                  Client.options(client, []))
  end

  @doc """
  [https://www.hipchat.com/docs/apiv2/method/view_group](https://www.hipchat.com/docs/apiv2/method/view_group)
  """
  @spec get_group(Client.t, String.t) :: Httpc.res_t
  def get_group(client, group_id) do
    Httpc.request(:get,
                  "#{@endpoint}/group/#{group_id}",
                  "",
                  Client.headers(client),
                  Client.options(client, []))
  end

  @doc """
  [https://www.hipchat.com/docs/apiv2/method/get_group_avatar](https://www.hipchat.com/docs/apiv2/method/get_group_avatar)
  """
  @spec get_group_avatar(Client.t, String.t) :: Httpc.res_t
  def get_group_avatar(client, group_id) do
    Httpc.request(:get,
                  "#{@endpoint}/group/#{group_id}/avatar",
                  "",
                  Client.headers(client),
                  Client.options(client, []))
  end

  @doc """
  [https://www.hipchat.com/docs/apiv2/method/group_statistics](https://www.hipchat.com/docs/apiv2/method/group_statistics)
  """
  @spec get_group_statistics(Client.t, String.t) :: Httpc.res_t
  def get_group_statistics(client, group_id) do
    Httpc.request(:get,
                  "#{@endpoint}/group/#{group_id}/statistics",
                  "",
                  Client.headers(client),
                  Client.options(client, []))
  end

  @doc """
  [https://www.hipchat.com/docs/apiv2/method/update_group_avatar](https://www.hipchat.com/docs/apiv2/method/update_group_avatar)
  """
  @spec update_group_avatar(Client.t, String.t, map) :: Httpc.res_t
  def update_group_avatar(client, group_id, body) do
    Httpc.request(:put,
                  "#{@endpoint}/group/#{group_id}/avatar",
                  {:form, Map.to_list(body)},
                  Client.headers(client),
                  Client.options(client, []))
  end
end
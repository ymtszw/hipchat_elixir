# Code generated by `$ mix hipchat.generate`
defmodule Hipchat.V2.Api.Invites do
  @moduledoc """
  HipChat V2 Invites API module.
  """

  alias Hipchat.V2.Client

  @doc """
  Invites a user to join a group.

  Authentication required, with scope admin_group.

  Accessible by group clients, users.

  https://www.hipchat.com/docs/apiv2/method/invite_user_to_group
  """
  @spec invite_user_to_group(Client.t, map) :: Client.res_t
  def invite_user_to_group(client, body) do
    Client.send_request(client, :post, "/invite/user", [], body)
  end
end
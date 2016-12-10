defmodule ExHipchat do
  @moduledoc """
  Elixir API client for [HipChat](https://www.hipchat.com/docs/apiv2).

  Supports basic functionality for Add-On and/or simple messaging-bot development.
  """

  @endpoint_url "https://api.hipchat.com"

  def endpoint_url, do: @endpoint_url
end

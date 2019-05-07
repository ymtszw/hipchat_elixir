# :warning: DISCONTINUATION NOTICE

[HipChat itself is discontinued by Atlassian due to their partnership with Slack](https://www.atlassian.com/partnerships/slack).

This Elixir library is therefore no longer maintained, and goes archive. Thanks for your interest though! :heart:

# hipchat_elixir

[![Hex.pm](https://img.shields.io/hexpm/v/hipchat_elixir.svg)](https://hex.pm/packages/hipchat_elixir)
[![CircleCI](https://circleci.com/gh/ymtszw/hipchat_elixir/tree/master.svg?style=svg)](https://circleci.com/gh/ymtszw/hipchat_elixir/tree/master)

HipChat client library for [Elixir](http://elixir-lang.org).

- [API Documentation](https://hexdocs.pm/hipchat_elixir)

## Policy

- Using Erlang's built-in `httpc` as HTTP client, for easier dependency management.
- No state. Access tokens and other credentials should be retrieved/stored by caller applications.
- Relying on HipChat cloud for parameter validations.
- Covering APIs used in server side only.
- Generating codes from Swagger (OpenAPI) specifications in [ymtszw/hipchat_swagger](https://github.com/ymtszw/hipchat_swagger).
    - Read more in [here][contributions].

[contributions]: https://hexdocs.pm/hipchat_elixir/contribution.html

## Basic Usage

0. Add [`:hipchat_elixir`](https://hex.pm/packages/hipchat_elixir) as a dependency.
1. Create client struct (`Hipchat.ApiClient.new/3`).
    - Pass `access_token` if the targeted API requires authentication.
    - See [here](https://hexdocs.pm/hipchat_elixir/authentication.html) for details.
2. Pass the resultant client and other parameters to the targeted API function.

  ```elixir
  Hipchat.ApiClient.new("access_token")
  |> Hipchat.V2.Rooms.send_room_notification("room_id", %{message: "Hello HipChat!"})
  # {:ok, %Hipchat.Httpc.Response{body: "", headers: ..., status: 204}}
  ```

## About `Content-Type`

Request bodies are sent as `content-type: application/json` or
`content-type: x-www-form-urlencoded` depending on `:serializer` config value.

- See [`config/config.exs`](https://github.com/ymtszw/hipchat_elixir/blob/master/config/config.exs) for example.
- Some HipChat APIs (implicitly) require `content-type: application/json`,
  so **introducing JSON serializer is almost mandatory**.
    - Currently only supports [`Poison`](https://github.com/devinus/poison).

## Status

Basic chat related APIs (CRUD operation of rooms/users, sending messages/notifications, etc) are covered.

Many add-on (extension) related APIs are not covered.
Since HipChat itself is sunsetting and moving toward [Stride](https://www.stride.com/),
I may not revisit to perfect these. If interested, [contributions] are welcomed.

Only supports HipChat cloud (not HipChat server).

# License

MIT

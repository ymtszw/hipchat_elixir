# hipchat_elixir

[![Hex.pm](https://img.shields.io/hexpm/v/hipchat_elixir.svg)](https://hex.pm/packages/hipchat_elixir)

HipChat client library for [Elixir](http://elixir-lang.org).

Generated from HipChat Swagger API specifications in [ymtszw/hipchat_swagger](https://github.com/ymtszw/hipchat_swagger).

Depends on `hackney` for HTTP client.

# Policy

- No state. Access tokens and other credentials should be retrieved/stored by caller applications.
- Relying HipChat cloud/server for parameter validations.
- Cover APIs used in server side only.

# Usage

0. Add [`:hipchat_elixir`](https://hex.pm/packages/hipchat_elixir) as a dependency
1. Create client struct (e.g. `Hipchat.V2.Client.new/3`).
    - Pass `access_token` if the targeted API requires authentication.
    - `access_token` can be one of four types (according to
      [the doc](https://developer.atlassian.com/hipchat/guide/hipchat-rest-api/api-access-tokens)):
        - Add-on token (need OAuth2 flow beforehand)
        - User token (need OAuth2 flow beforehand)
        - Personal access token
        - Room notification token
2. Pass the resultant client and other parameters to the targeted API function.
  ```elixir
  retrieve_access_token # Implementation is up to your app
  |> Hipchat.V2.Client.new
  |> Hipchat.V2.Api.send_room_notification(room_id, %{"message" => "Hello hipchat!"})
  # {:ok, %Hipchat.Httpc.Response{body: "", headers: ..., status: 204}}
  ```

# Todo

- [ ] Generate other APIs.
- [ ] Helper for handling OAuth client ID and secrets to retrieve short-lived Add-on token or User token.

# License

MIT

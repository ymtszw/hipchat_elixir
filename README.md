# hipchat_elixir

HipChat client library for [Elixir](http://elixir-lang.org).

Generated from HipChat Swagger API specifications in [ymtszw/hipchat_swagger](https://github.com/ymtszw/hipchat_swagger).

Depends on `hackney` for HTTP client, and `Poison` for JSON parser.

# Basic Usage

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

# License

MIT

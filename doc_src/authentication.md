# HipChat API Authentication

## About `access_token`s

See [here](https://developer.atlassian.com/hipchat/guide/hipchat-rest-api/api-access-tokens) for complete coverage.

Though a little explanations will not hurt so here they are:

### Add-on token or User token Retrieval

They are automatically generated and retrieved after installations (in case of User tokens, upon users' approval, at least) .

To do that with this library:

0. Prepare your Add-on server with:
    - [Installation Flow](https://developer.atlassian.com/hipchat/guide/installation-flow) handling logics,
      which involves:
        - Capability descriptor endpoint URL
        - Stable storage for `client_id` and `client_secret` per installation
    - (For User token) Callback URL to which users are redirected after approval
1. Create an OAuth client struct (`Hipchat.OauthClient.new/3`) with generated `client_id` and `client_secret`.
2. Create a body which must include `grant_type` and other requirements.
    - `grant_type` should be:
        - `client_credentials` for Add-on token
        - `authorization_code` for initial retrieval of User tokens
        - `refresh_token` for refreshing User tokens
    - See [here](https://developer.atlassian.com/hipchat/guide/hipchat-rest-api/api-access-tokens) for details.
3. Request with OAuth Sessions API function.

  ```elixir
  Hipchat.OauthClient.new("client_id", "client_secret")
  |> Hipchat.V2.OauthSessions.generate_token(%{grant_type: "client_credentials", scope: "send_notification"})
  # {:ok, %Hipchat.Httpc.Response{body: "<should contain access_token>", headers: ..., status: 200}}
  ```

4. Your server have to store generated `access_token`s (and `refresh_token`s) for later uses. If they expire, re-generate or refresh.

### User generated tokens

After logging in to HipChat, you can manually generate Personal Access Tokens with arbitrary access `scope`s,
or room-only Notification Tokens.

They are convenient because,
(1) they do not require automatic installation logics on your server and,
(2) they are semi-permanent (year-long expiration as of 2016/12).

If you just need notifications or other limited-scope actions in your Add-on or Bots,
they come in very handy.

**Be sure to properly control visibility of those tokens**.
They must be visible only to their owners and trusted third parties, as with any other similar API credentials out in the world.

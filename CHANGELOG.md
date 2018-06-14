# Change Log

Log (mostly) breaking changes only.

## 0.5.0 (coming)

- Drop hackney dependency, use Erlang's `httpc`

## 0.4.0 (around [78c251e](https://github.com/ymtszw/hipchat_elixir/commit/78c251edf2ed23092f031322655a95d2598430d6))

- JSON serializer config is now retrieved at runtime (not requiring `mix deps.compile hipchat_elixir`)
- `Hipchat.Httpc.Request` structs now have `:request` field

## 0.3.0 (around [241bd9f](https://github.com/ymtszw/hipchat_elixir/commit/241bd9f19623e876ad5a7019458ab341f49c399a))

- Relax hackney version requirements (thanks to [@rodrigues](https://github.com/rodrigues))

## 0.2.3 (around [5555d24](https://github.com/ymtszw/hipchat_elixir/commit/5555d246384b940168d352d21b1f7231c9a8028c))

- Add JSON serializer support
    - Set `:serializer` option in your config for `:hipchat_elixir`.
    - E.g. `config :hipchat_elixir, [serializer: Poison]`
    - Currently only works with [`Poison`](https://github.com/devinus/poison)

## 0.2.0 (around [7795804](https://github.com/ymtszw/hipchat_elixir/commit/7795804ecc4c488c5989ce8ccb932f3377eac51d))

- Change in module naming style
    - Now `Hipchat.<version>.<basename>`, instead of `Hipchat.<version>.Api.<basename>`
- Change in client struct
    - Now `Hipchat.ApiClient` or `Hipchat.OauthClient`, instead of `Hipchat.<version>.Client`
- Change in directory structures
- Add OAuth Sessions API

## 0.1.0

- First release with some working APIs

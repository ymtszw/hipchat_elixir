use Mix.Config

# These are configs for development/test/example
config :hipchat_elixir, [
  # Set request body serializer module. Currently only accepts `Poison` or `:form`.
  # If `:form`, it tries to send requests with `content-type: x-www-form-urlencoded` (Note that some HipChat APIs might reject them).
  # Otherwise `content-type: application/json` is used. Defaults to `Poison`.
  serializer: Poison,
]

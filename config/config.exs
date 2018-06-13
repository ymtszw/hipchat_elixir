use Mix.Config

secrets_file = Path.expand(Path.join(__DIR__, "secrets.exs"))
if Mix.env() in [:dev, :test] and File.regular?(secrets_file) do
  import_config secrets_file # For development of this library.
end

config :hipchat_elixir, [
  # Set request body serializer module. Currently only accepts `Poison` or `:form`.
  # If `:form`, it tries to send requests with `content-type: x-www-form-urlencoded` (Note that some HipChat APIs might reject them).
  # Otherwise `content-type: application/json` is used. Defaults to `Poison`.
  serializer: Poison,
]

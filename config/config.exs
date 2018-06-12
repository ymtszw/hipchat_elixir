use Mix.Config

secrets_file = Path.expand(Path.join(__DIR__, "secrets.exs"))
if Mix.env() in [:dev, :test] and File.regular?(secrets_file) do
  import_config secrets_file # For development of this library.
end

use Mix.Config

if Mix.env in [:dev, :test] do
  import_config "secrets.exs" # For development of this library.
end

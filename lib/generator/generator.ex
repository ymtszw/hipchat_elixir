defmodule ExHipchat.Generator do
  alias ExHipchat.Yaml

  @root_dir   Path.expand(Path.join([__DIR__, "..", ".."]))
  @lib_dir    Path.join([@root_dir, "lib"])
  @spec_files Path.wildcard(Path.join([@root_dir, "hipchat_swagger", "*.yaml"]))

  def generate do
    Enum.each(@spec_files, fn spec_file ->
      {:ok, %{
        "info" => %{
          "version" => version,
        },
        "host" => host,
        "basePath" => base_path,
        "paths" => _paths,
      }} = Yaml.from_file(spec_file)
      ensure_directory(version)
      generate_client(version, host, base_path)
      # generate_apis(version, paths)
    end)
  end

  defp ensure_directory(version) do
    case Path.join([@lib_dir, version]) |> File.mkdir do
      :ok               -> :ok
      {:error, :eexist} -> :ok
    end
  end

  defp generate_client(version, host, base_path) do
    template = Path.join([__DIR__, "template", "client.eex"])
    target   = Path.join([@lib_dir, version, "client.ex"])
    content  = EEx.eval_file(template, version: version, host: host, base_path: base_path)
    case File.write(target, content) do
      :ok              -> IO.puts(IO.ANSI.format([:green, "Generated: ", :reset, target]))
      {:error, reason} -> IO.puts(IO.ANSI.format([:red, "Error: ", :reset, inspect(reason)]))
    end
  end

  # defp generate_apis(version, paths) do
  #   template = Path.join([__DIR__, "template", "api.eex"])
  #   Enum.group_by
  # end
end

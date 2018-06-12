defmodule Hipchat.Generator do
  @moduledoc false

  alias Hipchat.Generator.Yaml

  @root_dir   Path.expand(Path.join([__DIR__, ".."]))
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
        "paths" => paths,
      }} = Yaml.from_file(spec_file)
      ensure_directories(version)
      generate_apis(version, host, base_path, paths)
    end)
  end

  defp ensure_directories(version) do
    File.mkdir_p!(Path.join([@lib_dir, version]))
  end

  defp generate_apis(version, host, base_path, paths) do
    template = Path.join([__DIR__, "template", "api.eex"])
    normalize_paths(paths)
    |> Enum.each(fn {basename, apis} ->
      target  = Path.join([@lib_dir, version, Macro.underscore(basename) <> ".ex"])
      params  = [
        version:   version,
        host:      host,
        base_path: base_path,
        basename:  basename,
        apis:      Enum.sort_by(apis, &elem(&1, 2)),
      ]
      content = EEx.eval_file(template, params)
      write_file(target, content)
    end)
  end

  defp write_file(target, content) do
    case File.write(target, content) do
      :ok              -> IO.puts(IO.ANSI.format([:green, "Generated: ", :reset, target]))
      {:error, reason} -> IO.puts(IO.ANSI.format([:red, "Error: ", :reset, inspect(reason)]))
    end
  end

  defp normalize_paths(paths) do
    Enum.flat_map(paths, fn {path, api_per_method} ->
      Enum.map(api_per_method, fn {method, api_detail} ->
        %{
          "summary"     => summary,
          "description" => desc,
          "tags"        => [tag], # Assuming only one tag per API.
        } = api_detail
        basename = String.replace(tag, " ", "")
        identifier = String.replace(summary, ~r/ +/, "_") |> String.downcase
        interpolatable_path = String.replace(path, "{", "\#{")
        {path_params, has_query?, has_body?} = api_detail |> Map.get("parameters", []) |> extract_params
        link = String.split(desc, "\n", trim: true) |> Enum.reverse |> hd
        {basename, {link, method, identifier, interpolatable_path, path_params, has_query?, has_body?}}
      end)
    end)
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
  end

  defp extract_params(params) do
    path_params = params |> Enum.filter(fn %{"in" => pin} -> pin == "path" end) |> Enum.map(&Map.get(&1, "name"))
    has_query?  = Enum.any?(params, fn %{"in" => pin} -> pin == "query" end)
    has_body?   = Enum.any?(params, fn %{"in" => pin} -> pin == "body" end)
    {path_params, has_query?, has_body?}
  end
end

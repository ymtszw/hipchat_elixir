defmodule ExHipchat.YamlTest do
  use Croma.TestCase

  @template_file Path.expand(Path.join([__DIR__, "..", "..", "spec", "template.yaml"]))

  test "should read YAML file and convert to map" do
    IO.puts(@template_file)
    assert {:ok, map} = Yaml.from_file(@template_file)
    assert map == %{
      "<method>_<identifier1>" => %{
        "path"         => "/<version>/<seg>/:snake_cased_param/<seg>",
        "doc"          => """
          First line (header of the function doc). Vertical bar above is required for multiline heredoc in YAML.

          Third line and afterword. (body of the doc)
          This whole parameter is optional.
          """,
        "ref_link"     => "https://www.hipchat.com/docs/apiv2/method/get_capabilities",
        "query_params" => [
          %{
            "key_name"   =>  "key_name",
            "value_type" => "binary",
            "required"   => true,
          },
          %{
            "key_name"   => "key_name",
            "value_type" => "integer",
          },
        ],
        "body" => [
          %{
            "key_name"   => "key_name",
            "value_type" => "map",
            "required"   => true,
          },
          %{
            "key_name"   => "key_name",
            "value_type" => "boolean",
          },
        ]
      },
      "<method>_<identifier2>" => %{
        "path"     => "/<version>/<seg>/:snake_cased_param/<seg>",
        "ref_link" => "https://www.hipchat.com/docs/apiv2/method/get_capabilities",
      }
    }
  end
end

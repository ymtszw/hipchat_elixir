defmodule ExHipchat.YamlTest do
  use Croma.TestCase

  @example_file Path.join([__DIR__, "example.yaml"])

  test "should read YAML file and convert to map" do
    assert {:ok, map} = Yaml.from_file(@example_file)
    assert map == %{
      "paths" => %{
        "/capabilities" => %{
          "get" => %{
            "summary"     => "Get Capabilities",
            "description" => """
              Gets the capabilities descriptor for HipChat

              Authentication not required.

              https://www.hipchat.com/docs/apiv2/method/get_capabilities
              """,
            "tags" => ["Capabilities"],
            "responses" => %{
              "200" => %{
                "description" => "Capabilities",
                "schema" => %{
                  "type" => "object"
                },
              },
            },
          },
        },
      },
    }
  end
end

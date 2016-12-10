use Croma

defmodule ExHipchat.Httpc do
  alias Croma.Result, as: R

  defmodule Method do
    use Croma.SubtypeOfAtom, values: [:get, :post, :put, :delete]
  end

  defmodule Response do
    use Croma.Struct, fields: [
      status:  Croma.NonNegInteger,
      headers: Croma.List,
      body:    Croma.String,
    ]
  end

  defmacro __using__(_) do
    quote do
      alias ExHipchat.{Httpc, Method}
      alias ExHipchat.Httpc.Response, as: Res
    end
  end

  defun request(method :: v[Method.t], url :: v[String.t], body :: v[String.t], headers :: Keyword.t, options0 :: Keyword.t \\ []) :: R.t(Response.t) do
    options = [{:with_body, true} | options0]
    case :hackney.request(method, url, headers, body, options) do
      {:ok, status, headers, body} -> Response.new(%{status: status, headers: headers, body: body})
      {:ok, status, headers}       -> Response.new(%{status: status, headers: headers, body: ""})
      # Won't use stream mode so its branch is omitted
      error_tuple                  -> error_tuple
    end
  end
end

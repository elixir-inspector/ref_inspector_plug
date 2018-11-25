defmodule RefInspector.Plug do
  @moduledoc """
  RefInspector Plug

  ## Usage

  After ensuring `:ref_inspector` is configured you need to add the plug:

      defmodule MyRouter do
        use Plug.Router

        # ...
        plug RefInspector.Plug
        # ...

        plug :match
        plug :dispatch
      end

  Depending on how you are using plugs the actual location may vary.
  Please consult your frameworks documentation to find the proper place.

  Once setup the connection will be automatically enriched with the results of
  a lookup based on the connections `referer` header:

      defmodule MyRouter do
        get "/" do
          case RefInspector.Plug.get_result(conn) do
            %{referer: ""} -> send_resp(conn, 404, "Missing referer")
            %{source: :unknown} -> send_resp(conn, 200, "Unknown referer")
            %{source: source} -> send_resp(conn, 200, "Client source: " <> source)
          end
        end
      end
  """

  import Plug.Conn

  @behaviour Plug

  def init(opts), do: opts

  def call(conn, _opts) do
    lookup =
      case get_req_header(conn, "referer") do
        [] -> RefInspector.parse(nil)
        [referer | _] -> RefInspector.parse(referer)
      end

    put_private(conn, :ref_inspector, lookup)
  end

  @doc """
  Returns the lookup result from the connection.
  """
  @spec get_result(Plug.Conn.t()) :: nil | RefInspector.Result.t()
  def get_result(conn), do: conn.private[:ref_inspector]
end

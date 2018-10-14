defmodule RefInspector.Plug do
  @moduledoc """
  RefInspector Plug
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

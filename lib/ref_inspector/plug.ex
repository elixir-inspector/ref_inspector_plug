defmodule RefInspector.Plug do
  @moduledoc """
  RefInspector Plug
  """

  @behaviour Plug

  def init(opts), do: opts

  def call(conn, _opts), do: conn
end

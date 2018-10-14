defmodule RefInspector.PlugTest do
  use ExUnit.Case
  use Plug.Test

  @referer "http://www.google.com/search?q=ref_inspector"

  defmodule Router do
    use Plug.Router

    plug RefInspector.Plug

    plug :match
    plug :dispatch

    get "/", do: send_resp(conn, 200, "OK")
  end

  @opts Router.init([])

  test "empty result for empty referer" do
    conn = conn(:get, "/") |> Router.call(@opts)

    assert 200 == conn.status
    assert %RefInspector.Result{referer: ""} == RefInspector.Plug.get_result(conn)
  end

  test "result for referer" do
    conn =
      conn(:get, "/")
      |> put_req_header("referer", @referer)
      |> Router.call(@opts)

    assert 200 == conn.status

    assert %RefInspector.Result{
             referer: @referer,
             source: "Google"
           } = RefInspector.Plug.get_result(conn)
  end
end

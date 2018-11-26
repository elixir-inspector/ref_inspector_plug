defmodule RefInspector.PlugTest do
  use ExUnit.Case
  use Plug.Test

  defmodule Router do
    use Plug.Router

    plug RefInspector.Plug

    plug :match
    plug :dispatch

    get "/" do
      case RefInspector.Plug.get_result(conn) do
        %{referer: ""} -> send_resp(conn, 404, "Missing referer")
        %{source: :unknown} -> send_resp(conn, 404, "Unknown referer")
        %{source: source} -> send_resp(conn, 200, "Referer source: " <> source)
      end
    end
  end

  @opts Router.init([])

  test "nil result if no lookup performed" do
    assert nil == conn(:get, "/") |> RefInspector.Plug.get_result()
  end

  test "empty result for empty referer" do
    conn = conn(:get, "/") |> Router.call(@opts)

    assert 404 == conn.status

    assert %RefInspector.Result{
             referer: ""
           } == RefInspector.Plug.get_result(conn)
  end

  test "empty result for unknown referer" do
    referer = "http://my.site/search?q=ref_inspector"

    conn =
      conn(:get, "/")
      |> put_req_header("referer", referer)
      |> Router.call(@opts)

    assert 404 == conn.status

    assert %RefInspector.Result{
             referer: referer,
             source: :unknown
           } == RefInspector.Plug.get_result(conn)
  end

  test "result for referer" do
    referer = "http://www.google.com/search?q=ref_inspector"

    conn =
      conn(:get, "/")
      |> put_req_header("referer", referer)
      |> Router.call(@opts)

    assert 200 == conn.status

    assert %RefInspector.Result{
             referer: referer,
             source: "Google"
           } = RefInspector.Plug.get_result(conn)
  end
end

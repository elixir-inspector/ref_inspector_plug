defmodule RefInspector.Plug.SessionTest do
  use ExUnit.Case

  import Plug.Conn
  import Plug.Test

  alias RefInspector.Plug.TestHelpers.SessionStore

  defmodule Router do
    use Plug.Router

    plug Plug.Session,
      store: SessionStore,
      key: "session_cookie"

    plug :fetch_session

    plug RefInspector.Plug,
      use_session: true,
      session_key: "ref_inspector_test"

    plug :match
    plug :dispatch

    get "/", do: send_resp(conn, 204, "")
  end

  @opts Router.init([])

  test "result stored in session" do
    referer = "http://www.google.com/search?q=ref_inspector"

    conn =
      conn(:get, "/")
      |> put_req_header("referer", referer)
      |> Router.call(@opts)

    assert %RefInspector.Result{
             referer: ^referer,
             source: "Google"
           } = RefInspector.Plug.get_result(conn)
  end

  test "result read from session" do
    result = %RefInspector.Result{referer: "prepopulated"}
    session_opts = Plug.Session.init(store: SessionStore, key: "session_cookie")

    conn =
      conn(:get, "/")
      |> Plug.Session.call(session_opts)
      |> fetch_session()
      |> put_session("ref_inspector_test", result)
      |> Router.call(@opts)

    assert result == RefInspector.Plug.get_result(conn)
  end
end

alias RefInspector.Plug.TestHelpers.Retry

true = Retry.retry(5000, 10, &RefInspector.ready?/0, & &1)

ExUnit.start()

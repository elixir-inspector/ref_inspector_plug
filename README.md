# RefInspector Plug

## Package Setup

Add the library as a dependency to your `mix.exs` file:

```elixir
defp deps do
  [
    # ...
    {:ref_inspector_plug, "~> 0.1.0"}
    # ...
  ]
end
```

## Application Setup

### Configuration

Ensure `:ref_inspector` is configured properly. There are no additional configuration steps necessary.

### Plug

To automatically parse a clients referer and enrich the connection you need to add the plug into your current pipeline:

```elixir
defmodule MyRouter do
  use Plug.Router

  # ...
  plug RefInspector.Plug
  # ...

  plug :match
  plug :dispatch
end
```

Depending on how you are using plugs the actual location may vary. Please consult your frameworks documentation to find the proper place.

Once setup the connection will be automatically enriched with the results of a lookup based on the connections `referer` header:

```elixir
defmodule MyRouter do
  get "/" do
    case RefInspector.Plug.get_result(conn) do
      nil -> send_resp(conn, 500, "No lookup done")
      %{referer: ""} -> send_resp(conn, 404, "Missing referer")
      %{source: :unknown} -> send_resp(conn, 404, "Unknown referer")
      %{source: source} -> send_resp(conn, 200, "Referer source: " <> source)
    end
  end
end
```

## License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)

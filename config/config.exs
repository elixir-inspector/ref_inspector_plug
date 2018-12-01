use Mix.Config

if Mix.env() == :test do
  config :ref_inspector,
    database_path: Path.join(__DIR__, "../test/database")
end

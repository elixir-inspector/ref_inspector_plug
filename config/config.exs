use Mix.Config

if Mix.env() == :test do
  config :ref_inspector, database_path: Path.expand("../test/database", __DIR__)
end

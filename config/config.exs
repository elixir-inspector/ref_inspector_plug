use Mix.Config

if Mix.env() == :test do
  config :ref_inspector,
    database_path: Path.expand("../test/database", __DIR__),
    remote_urls: [
      {"referers.yml",
       "https://raw.githubusercontent.com/snowplow-referer-parser/referer-parser/master/resources/referers.yml"}
    ],
    startup_silent: true,
    startup_sync: true
end

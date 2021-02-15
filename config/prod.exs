use Mix.Config

config :xq_archive, XQ.ArchiveWeb.Endpoint,
  url: [host: "archive.playxiangqi.xyz", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json"

# Do not print debug messages in production
config :logger, level: :info

# Finally import the config/prod.secret.exs which loads secrets
# and configuration from environment variables.
import_config "prod.secret.exs"

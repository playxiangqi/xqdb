use Mix.Config

config :xq_archive, XQ.ArchiveWeb.Endpoint, url: [host: "archive.playxiangqi.xyz", port: 80]

# Do not print debug messages in production
config :logger, level: :info

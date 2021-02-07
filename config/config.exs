# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :xq_tablebase,
  namespace: XQ.Tablebase,
  ecto_repos: [XQ.Tablebase.Repo]

# Configures the endpoint
config :xq_tablebase, XQ.TablebaseWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "JfljE76P4DcG9yad8I3niRuqNqp6k2oJhb94yWInfHFk68UEQj3f50TrjwdFUCsl",
  render_errors: [view: XQ.TablebaseWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: XQ.Tablebase.PubSub,
  live_view: [signing_salt: "xnk6twTh"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

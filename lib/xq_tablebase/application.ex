defmodule XQ.Tablebase.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      XQ.Tablebase.Repo,
      # Start the Telemetry supervisor
      XQ.TablebaseWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: XQ.Tablebase.PubSub},
      # Start the Endpoint (http/https)
      XQ.TablebaseWeb.Endpoint
      # Start a worker by calling: XQ.Tablebase.Worker.start_link(arg)
      # {XQ.Tablebase.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: XQ.Tablebase.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    XQ.TablebaseWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

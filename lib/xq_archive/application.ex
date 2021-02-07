defmodule XQ.Archive.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      XQ.Archive.Repo,
      # Start the Telemetry supervisor
      XQ.ArchiveWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: XQ.Archive.PubSub},
      # Start the Endpoint (http/https)
      XQ.ArchiveWeb.Endpoint
      # Start a worker by calling: XQ.Archive.Worker.start_link(arg)
      # {XQ.Archive.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: XQ.Archive.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    XQ.ArchiveWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

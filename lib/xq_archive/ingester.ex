defmodule XQ.Archive.Ingester do
  use Supervisor

  alias XQ.Archive.Ingester.Pipeline

  require Logger

  # Supervisor
  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    children = [
      Pipeline
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  # Client
  def push_batch(batch) when is_list(batch) do
    Logger.info("push_batch: #{inspect(batch)}")

    GenStage.cast(Enum.random(Broadway.producer_names(Pipeline)), {:push, batch})
  end
end

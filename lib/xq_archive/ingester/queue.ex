defmodule XQ.Archive.Ingester.Queue do
  use GenStage

  require Logger

  def start_link(_), do: GenStage.start_link(__MODULE__, [], name: __MODULE__)

  @impl true
  def init(_), do: {:producer, {[], 0}}

  @impl true
  def handle_cast({:push, batch}, {queue, debt}) when is_list(batch) do
    Logger.info("handle_cast: available: #{inspect(queue)}, owe: #{inspect(debt)}")

    {to_dispatch, remaining} = Enum.split(batch ++ queue, debt)
    Logger.info("to_dispatch: #{inspect(to_dispatch)}, remaining: #{inspect(remaining)}")

    {:noreply, to_dispatch, {remaining, debt - length(to_dispatch)}}
  end

  @impl true
  def handle_demand(demand, {queue, debt}) do
    Logger.info("handle_demand: available: #{inspect(queue)}, owe: #{inspect(debt)}")

    {to_dispatch, remaining} = Enum.split(queue, demand)
    Logger.info("to_dispatch: #{inspect(to_dispatch)}, remaining: #{inspect(remaining)}")

    {:noreply, to_dispatch, {remaining, demand + debt - length(to_dispatch)}}
  end
end

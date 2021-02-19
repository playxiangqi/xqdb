defmodule XQ.Archive.Ingester.Pipeline do
  use Broadway

  alias Broadway.Message
  alias XQ.Archive.{Game, Repo}
  alias XQ.Archive.Ingester.{Core, Queue}

  require Logger

  def start_link(_) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {Queue, []},
        transformer: {__MODULE__, :transform, []}
      ],
      processors: [
        ingest: [concurrency: 5]
      ],
      batchers: [
        batch_insert: [
          concurrency: 1,
          batch_size: 100,
          batch_timeout: 1_000
        ]
      ]
    )
  end

  # Processors
  @impl true
  def handle_message(:ingest, message, _context) do
    message
    |> Message.update_data(&Core.unmarshal_game(&1))
    |> Message.update_data(&Map.merge(&1, timestamps()))
    |> Message.put_batcher(:batch_insert)
  end

  defp timestamps() do
    now = DateTime.utc_now()
    %{inserted_at: now, updated_at: now}
  end

  def transform(event, _opts) do
    %Message{
      data: event,
      acknowledger: {__MODULE__, :ack_id, :ack_data}
    }
  end

  def ack(_ack_ref, successful, []) do
    Logger.info("#{inspect(successful)}")

    :ok
  end

  def ack(_ack_ref, _successful, failed) do
    Logger.error("#{inspect(failed)}")

    :ok
  end

  # Batchers
  @impl true
  def handle_batch(:batch_insert, messages, _batch_info, _context) do
    messages
    |> Enum.map(fn %Message{data: games} -> games end)
    |> batch_insert(messages)
  end

  defp batch_insert(games, messages) do
    case Repo.insert_all(
           Game,
           games,
           on_conflict: {:replace_all_except, [:id, :inserted_at]},
           conflict_target: [:source_id]
         ) do
      {n, _} when n == length(games) ->
        messages

      result ->
        batch_failed(messages, {:insert_all, result})
    end
  end

  defp batch_failed(messages, reason) do
    Enum.map(messages, &Message.failed(&1, reason))
  end
end

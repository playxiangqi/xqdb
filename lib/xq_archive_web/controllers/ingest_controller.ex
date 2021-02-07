defmodule XQ.ArchiveWeb.IngestController do
  use XQ.ArchiveWeb, :controller

  alias XQ.Archive.{Game, Repo}

  def ingest(conn, %{"games" => games}) do
    now = DateTime.utc_now()

    new_games =
      games
      |> Enum.map(fn g -> unmarshal(g) end)
      |> Enum.map(fn g -> Map.merge(g, %{inserted_at: now, updated_at: now}) end)

    Repo.insert_all(
      Game,
      new_games,
      on_conflict: {:replace_all_except, [:id, :inserted_at]},
      conflict_target: [:source_id]
    )

    conn
    |> put_status(:created)
    |> json(%{games_count: length(new_games)})
  end

  defp unmarshal(
         %{
           "date" => raw_date,
           "result" => result,
           "red_player" => red_player,
           "black_player" => black_player,
           "source" => source,
           "source_id" => source_id,
           "opening_id" => opening_id,
           "move_count" => move_count,
           "moves" => moves,
           "data" => data
         } = game
       ) do
    {:ok, date, _} = DateTime.from_iso8601(raw_date)

    %{
      date: date,
      event: Map.get(game, "event"),
      result: result,
      rated: Map.get(game, "rated", false),
      red_club: Map.get(game, "red_club"),
      red_player: red_player,
      red_rating: Map.get(game, "red_rating"),
      black_club: Map.get(game, "black_club"),
      black_player: black_player,
      black_rating: Map.get(game, "black_rating"),
      source: source,
      source_id: source_id,
      time_control: Map.get(game, "time_control"),
      opening_id: opening_id,
      move_count: move_count,
      moves: moves,
      data: data
    }
  end
end

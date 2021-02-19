defmodule XQ.Archive.Ingester.Core do
  def unmarshal_game(
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
    %{
      date: DateTime.from_unix!(raw_date, :millisecond) |> DateTime.truncate(:second),
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

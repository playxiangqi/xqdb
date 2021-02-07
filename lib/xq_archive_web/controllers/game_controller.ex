defmodule XQ.ArchiveWeb.GameController do
  use XQ.ArchiveWeb, :controller

  import Ecto.Query, only: [from: 2]

  require Logger

  alias XQ.Archive.{Game, Opening, Repo}

  def index(conn, _params) do
    query =
      from g in Game,
        join: o in Opening,
        on: g.opening_id == o.id,
        select: %{game: g, opening: o}

    games =
      Repo.all(query)
      |> Enum.map(fn %{game: g, opening: %Opening{} = o} ->
        Map.merge(g, %{
          opening_name: o.name,
          opening_code: o.code,
          opening_moves: o.moves
        })
        |> Map.drop(Game.hidden_fields())
      end)

    json(conn, games)
  end
end

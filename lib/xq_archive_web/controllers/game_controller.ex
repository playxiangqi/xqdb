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

    games = Enum.map(Repo.all(query), &prepare_response/1)
    json(conn, games)
  end

  def show_latest(conn, _params) do
    query =
      from g in Game,
        join: o in Opening,
        on: g.opening_id == o.id,
        order_by: [desc: g.date],
        limit: 1,
        select: %{game: g, opening: o}

    latest_game = prepare_response(Repo.one!(query))
    json(conn, latest_game)
  end

  def show_random(conn, _params) do
    query =
      from g in Game,
        join: o in Opening,
        on: g.opening_id == o.id,
        order_by: fragment("RANDOM()"),
        limit: 1,
        select: %{game: g, opening: o}

    random_game = prepare_response(Repo.one!(query))
    json(conn, random_game)
  end

  defp prepare_response(%{game: game, opening: opening}) do
    game
    |> Map.merge(%{
      opening_code: opening.id,
      opening_name: opening.name,
      opening_moves: opening.moves
    })
    |> Map.drop(Game.hidden_fields())
  end
end

defmodule XQ.ArchiveWeb.GameController do
  use XQ.ArchiveWeb, :controller

  import Ecto.Query, only: [from: 2]

  require Logger

  alias XQ.Archive.{Game, Opening, Repo}

  plug :validate_query_params,
       ~w(red_player black_player opening_id result source limit)
       when action in [:index]

  def index(conn, _params) do
    query =
      from g in Game,
        join: o in Opening,
        on: g.opening_id == o.id,
        select: %{game: g, opening: o}

    games =
      query
      |> prepare_search(conn.assigns.filters)
      |> Repo.all()
      |> Enum.map(&prepare_response/1)

    json(conn, games)
  end

  def show(conn, %{"id" => id}) do
    query =
      from g in Game,
        join: o in Opening,
        on: g.opening_id == o.id,
        select: %{game: g, opening: o}

    query =
      case id do
        "latest" ->
          from t in query,
            order_by: [desc: t.date],
            limit: 1

        "random" ->
          from t in query,
            order_by: fragment("RANDOM()"),
            limit: 1

        id ->
          from t in query,
            where: t.id == ^id
      end

    specific_game = prepare_response(Repo.one!(query))
    json(conn, specific_game)
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

  defp validate_query_params(%Plug.Conn{params: req_params} = conn, valid_params) do
    default_params = %{
      "limit" => 25
    }

    filters =
      for {k, v} <- req_params,
          Enum.member?(valid_params, k),
          into: default_params,
          do: {k, v}

    assign(conn, :filters, filters)
  end

  defp prepare_search(query, params) do
    Enum.reduce(params, query, fn {k, v}, q ->
      case String.downcase(k) do
        "limit" ->
          from p in q,
            limit: ^v

        _ ->
          from p in q,
            where: field(p, ^String.to_atom(k)) == ^v
      end
    end)
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

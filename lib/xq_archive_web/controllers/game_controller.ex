defmodule XQ.ArchiveWeb.GameController do
  use XQ.ArchiveWeb, :controller

  import Ecto.Query, only: [from: 2]

  require Logger

  alias XQ.Archive.{Game, Opening, Repo}

  plug :validate_query_params,
       ~w(red_player black_player opening_id result source limit min_moves max_moves)
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

        # Note: Could easily precompute both move_count and turn_count during ETL
        "min_moves" ->
          from p in q,
            where: field(p, :turn_count) >= ^v * 2

        "max_moves" ->
          from p in q,
            where: field(p, :turn_count) <= ^v * 2

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

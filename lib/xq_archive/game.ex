defmodule XQ.Archive.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :black_club, :string
    field :black_player, :string
    field :black_rating, :integer
    field :data, :map
    field :date, :utc_datetime
    field :event, :string
    field :move_count, :integer
    field :moves, {:array, :string}
    field :rated, :boolean, default: false
    field :red_club, :string
    field :red_player, :string
    field :red_rating, :integer
    field :result, :string
    field :source, :string
    field :source_id, :string
    field :time_control, :string
    field :opening_id, :id

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:source, :source_id, :date, :event, :time_control, :rated, :result, :red_club, :red_player, :red_rating, :black_club, :black_player, :black_rating, :data, :move_count, :moves])
    |> validate_required([:source, :source_id, :date, :event, :time_control, :rated, :result, :red_club, :red_player, :red_rating, :black_club, :black_player, :black_rating, :data, :move_count, :moves])
  end
end

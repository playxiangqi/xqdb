defmodule XQ.Archive.Game do
  use Ecto.Schema
  import Ecto.Changeset

  @hidden_fields [:__meta__, :__struct__, :inserted_at, :updated_at]

  @derive {Jason.Encoder, except: @hidden_fields}
  @timestamps_opts [type: :utc_datetime_usec]
  schema "games" do
    field :black_club, :string
    field :black_player, :string, null: false
    field :black_rating, :integer
    field :data, :map, null: false
    field :date, :utc_datetime, null: false
    field :event, :string
    field :move_count, :integer, null: false
    field :moves, {:array, :string}, null: false
    field :rated, :boolean, default: false
    field :red_club, :string
    field :red_player, :string, null: false
    field :red_rating, :integer
    field :result, :string, null: false
    field :source, :string, null: false
    field :source_id, :string, null: false
    field :time_control, :string
    field :opening_id, :id

    timestamps()
  end

  def hidden_fields, do: @hidden_fields

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [
      :source,
      :source_id,
      :date,
      :event,
      :time_control,
      :rated,
      :result,
      :red_club,
      :red_player,
      :red_rating,
      :black_club,
      :black_player,
      :black_rating,
      :data,
      :move_count,
      :moves
    ])
    |> validate_required([
      :source,
      :source_id,
      :date,
      :event,
      :time_control,
      :rated,
      :result,
      :red_club,
      :red_player,
      :red_rating,
      :black_club,
      :black_player,
      :black_rating,
      :data,
      :move_count,
      :moves
    ])
  end
end

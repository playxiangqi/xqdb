defmodule XQ.Archive.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :source, :string, null: false
      add :source_id, :string, null: false
      add :date, :utc_datetime, null: false
      add :event, :string
      add :time_control, :string
      add :rated, :boolean, default: false, null: false
      add :result, :string, null: false
      add :red_club, :string
      add :red_player, :string, null: false
      add :red_rating, :integer
      add :black_club, :string
      add :black_player, :string, null: false
      add :black_rating, :integer
      add :data, :map, null: false
      add :move_count, :integer
      add :moves, {:array, :string}
      add :opening_id, references(:openings, type: :string, on_delete: :nothing)

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:games, [:source_id])
    create index(:games, [:opening_id])
  end
end

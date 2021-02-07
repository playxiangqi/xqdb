defmodule XQ.Archive.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :source, :string
      add :source_id, :string
      add :date, :utc_datetime
      add :event, :string
      add :time_control, :string
      add :rated, :boolean, default: false, null: false
      add :result, :string
      add :red_club, :string
      add :red_player, :string
      add :red_rating, :integer
      add :black_club, :string
      add :black_player, :string
      add :black_rating, :integer
      add :data, :map
      add :move_count, :integer
      add :moves, {:array, :string}
      add :opening_id, references(:openings, on_delete: :nothing)

      timestamps()
    end

    create index(:games, [:opening_id])
  end
end

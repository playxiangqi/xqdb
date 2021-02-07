defmodule XQ.Archive.Repo.Migrations.AlterGamesNullability do
  use Ecto.Migration

  def change do
    alter table(:games) do
      modify :black_player, :string, null: false
      modify :data, :map, null: false
      modify :date, :utc_datetime, null: false
      modify :move_count, :integer, null: false
      modify :red_player, :string, null: false
      modify :result, :string, null: false
      modify :source, :string, null: false
    end

    create unique_index(:games, [:source_id])
  end
end

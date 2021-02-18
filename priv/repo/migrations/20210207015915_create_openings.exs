defmodule XQ.Archive.Repo.Migrations.CreateOpenings do
  use Ecto.Migration

  def change do
    create table(:openings, primary_key: false) do
      add :id, :string, primary_key: true, null: false
      add :name, :string
      add :moves, {:array, :string}

      timestamps(type: :utc_datetime_usec)
    end
  end
end

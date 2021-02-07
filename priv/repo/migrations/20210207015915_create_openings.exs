defmodule XQ.Archive.Repo.Migrations.CreateOpenings do
  use Ecto.Migration

  def change do
    create table(:openings) do
      add :code, :string
      add :name, :string
      add :moves, {:array, :string}

      timestamps([type: :utc_datetime_usec])
    end

  end
end

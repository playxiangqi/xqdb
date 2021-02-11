defmodule XQ.Archive.Repo.Migrations.AlterOpeningsNullability do
  use Ecto.Migration

  def change do
    alter table(:openings) do
      modify :code, :string, null: false
    end

    create unique_index(:openings, [:code])
  end
end

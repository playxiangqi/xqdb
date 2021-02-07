defmodule XQ.Archive.Opening do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime_usec]
  schema "openings" do
    field :code, :string
    field :moves, {:array, :string}
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(opening, attrs) do
    opening
    |> cast(attrs, [:code, :name, :moves])
    |> validate_required([:code, :name, :moves])
  end
end

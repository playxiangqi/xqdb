defmodule XQ.Archive.Opening do
  use Ecto.Schema
  import Ecto.Changeset

  @hidden_fields [:__meta__, :__struct__, :inserted_at, :updated_at]

  @primary_key {:id, :string, autogenerate: false}
  @derive {Jason.Encoder, except: @hidden_fields}
  @timestamps_opts [type: :utc_datetime_usec]
  schema "openings" do
    field :moves, {:array, :string}
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(opening, attrs) do
    opening
    |> cast(attrs, [:id, :name, :moves])
    |> validate_required([:id, :name, :moves])
  end
end

defmodule XQ.Tablebase.Repo do
  use Ecto.Repo,
    otp_app: :xq_tablebase,
    adapter: Ecto.Adapters.Postgres
end

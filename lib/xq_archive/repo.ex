defmodule XQ.Archive.Repo do
  use Ecto.Repo,
    otp_app: :xq_archive,
    adapter: Ecto.Adapters.Postgres
end

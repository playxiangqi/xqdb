defmodule XQ.ArchiveWeb.HealthController do
  use XQ.ArchiveWeb, :controller

  def index(conn, _params) do
    {:ok, vsn} = :application.get_key(:xq_archive, :vsn)

    conn
    |> put_status(200)
    |> json(%{
      healthy: true,
      version: to_string(vsn),
      build: Application.get_env(:xq_archive, :build),
      node_name: node()
    })
  end
end

defmodule XQ.ArchiveWeb.HealthController do
  use XQ.ArchiveWeb, :controller

  def index(conn, _params) do
    vsn = Application.spec(:xq_archive, :vsn)

    conn
    |> put_status(200)
    |> json(%{healhy: true, version: vsn, node_name: node()})
  end
end

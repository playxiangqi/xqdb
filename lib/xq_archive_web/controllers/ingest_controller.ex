defmodule XQ.ArchiveWeb.IngestController do
  use XQ.ArchiveWeb, :controller

  def ingest(conn, %{"games" => games}) do
    XQ.Archive.Ingester.push_batch(games)

    send_resp(conn, :ok, "Ingestion job submitted")
  end
end

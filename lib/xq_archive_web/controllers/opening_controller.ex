defmodule XQ.ArchiveWeb.OpeningController do
  use XQ.ArchiveWeb, :controller

  alias XQ.Archive.{Opening, Repo}

  def index(conn, _params) do
    json(conn, Repo.all(Opening))
  end
end

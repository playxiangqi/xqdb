defmodule XQ.ArchiveWeb.GameController do
  use XQ.ArchiveWeb, :controller

  alias XQ.Archive.{Game, Repo}

  def index(conn, _params) do
    json(conn, Repo.all(Game))
  end
end

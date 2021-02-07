defmodule XQ.ArchiveWeb.Router do
  use XQ.ArchiveWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", XQ.ArchiveWeb do
    pipe_through :api
  end
end

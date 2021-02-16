defmodule XQ.ArchiveWeb.Router do
  use XQ.ArchiveWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", XQ.ArchiveWeb do
    get "/health", HealthController, :index
  end

  scope "/api", XQ.ArchiveWeb do
    pipe_through :api

    get "/health", HealthController, :index
    get "/game", GameController, :index
    get "/openings", OpeningController, :index
    post "/ingest", IngestController, :ingest
  end
end

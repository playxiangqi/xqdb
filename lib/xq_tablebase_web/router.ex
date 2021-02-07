defmodule XQ.TablebaseWeb.Router do
  use XQ.TablebaseWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", XQ.TablebaseWeb do
    pipe_through :api
  end
end

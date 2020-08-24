defmodule AsciiCanvasWeb.Router do
  use AsciiCanvasWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", AsciiCanvasWeb do
    pipe_through :api
  end
end

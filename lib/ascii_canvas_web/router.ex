defmodule AsciiCanvasWeb.Router do
  use AsciiCanvasWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", AsciiCanvasWeb do
    pipe_through :api
    resources "/images", ImageController, except: [:new, :edit, :delete, :update]
  end
end

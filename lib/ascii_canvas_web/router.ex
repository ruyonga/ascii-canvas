defmodule AsciiCanvasWeb.Router do
  use AsciiCanvasWeb, :router
  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
  end
  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", AsciiCanvasWeb do
    pipe_through :api
    resources "/images", ImageController, except: [:new, :edit, :delete, :update]
  end
end

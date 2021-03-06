defmodule AsciiCanvasWeb.ImageView do
  use AsciiCanvasWeb, :view
  alias AsciiCanvasWeb.ImageView

  def render("index.json", %{images: images}) do
    %{data: render_many(images, ImageView, "image.json")}
  end

  def render("show.json", %{image: image}) do
    %{
      status: image.status,
      message: image.message,
      canvas: %{
        id: image.canvas.id,
        url: image.canvas.url
      }
    }
  end

  def render("image.json", %{image: image}) do
    %{
      id: image.id,
      url: image.url
    }
  end
end

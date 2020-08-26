defmodule AsciiCanvasWeb.ImageController do
  use AsciiCanvasWeb, :controller

  alias AsciiCanvas.Canvas
  alias AsciiCanvas.Canvas.{Image, DrawImage}
  alias AsciiCanvasWeb.ErrorView
  action_fallback AsciiCanvasWeb.FallbackController

  def index(conn, _params) do
    images =
      Canvas.list_images()
      |> Enum.map(fn i ->
        parse_url(i, conn)
      end)

    render(conn, "index.json", images: images)
  end

  def create(conn, %{"images" => image_params}) do
    Enum.all?(image_params, fn x -> Map.has_key?(x, "fill") || Map.has_key?(x, "boarder") end)
    |> case do
      true ->
        process_request(conn, image_params)

      _ ->
        conn
        |> put_status(400)
        |> put_view(ErrorView)
        |> render(
          "400.json",
          error_message: "Fill or boarder are required for each art to be drawn"
        )
    end
  end

  defp process_request(conn, image_params) do
    with {:ok, %Image{} = image} <- DrawImage.draw(image_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.image_path(conn, :show, image))
      |> render("show.json", image: parse_url(image, conn))
    end
  end

  def show(conn, %{"id" => id}) do
    image = Canvas.get_image!(id)
    render(conn, "show.json", image: image)
  end

  defp parse_url(image, conn), do: %{image | url: "#{request_url(conn)}/#{image.url}"}
end

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
    Enum.all?(image_params, fn x -> Map.has_key?(x, "fill") || Map.has_key?(x, "border") end)
    |> case do
      true ->
        process_request(conn, image_params)

      _ ->
        response = %{
          status: "failed",
          error: "Either fill or border are required for each shape to be drawn"
        }

        conn
        |> put_status(400)
        |> put_view(ErrorView)
        |> render(
          "400.json",
          error_message: response
        )
    end
  end

  defp process_request(conn, image_params) do
    with {:ok, %Image{} = image} <- DrawImage.draw(image_params) do

      response = %{
        status: "successful",
        message: "Canvas generated successfully",
        canvas: parse_url(image, conn)
      }

      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.image_path(conn, :show, image))
      |> render("show.json", image: response)
    end
  end

  def show(conn, %{"id" => id}) do
    image = Canvas.get_image!(id)
    render(conn, "show.json", image: image)
  end

  defp parse_url(image, conn), do: %{image | url: "#{request_url(conn)}/#{image.url}"}



end

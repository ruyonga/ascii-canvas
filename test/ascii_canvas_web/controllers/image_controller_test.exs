defmodule AsciiCanvasWeb.ImageControllerTest do
  use AsciiCanvasWeb.ConnCase

  alias AsciiCanvas.Canvas
  alias AsciiCanvas.Canvas.Image

  @create_attrs %{
    url: "some url"
  }

  @invalid_attrs %{id: nil, url: nil}

  def fixture(:image) do
    {:ok, image} = Canvas.create_image(@create_attrs)
    image
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all images", %{conn: conn} do
      conn = get(conn, Routes.image_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create image" do
    test "renders image when data is valid", %{conn: conn} do
      conn = post(conn, Routes.image_path(conn, :create), image: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.image_path(conn, :show, id))

      assert %{
               "id" => id,
               "url" => "some url"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.image_path(conn, :create), image: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_image(_) do
    image = fixture(:image)
    {:ok, image: image}
  end
end

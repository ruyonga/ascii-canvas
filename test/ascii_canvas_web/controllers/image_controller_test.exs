defmodule AsciiCanvasWeb.ImageControllerTest do
  use AsciiCanvasWeb.ConnCase
  alias AsciiCanvas.Canvas

  @create_attrs %{
    "images" => [
      %{
        "position" => %{
          "x" => 20,
          "y" => 20
        },
        "fill" => "-",
        "border" => "@",
        "length" => 10,
        "width" => 10,
        "shape" => "rectangle"
      },
      %{
        "position" => %{
          "x" => 20,
          "y" => 40
        },
        "fill" => "-",
        "border" => "@",
        "length" => 10,
        "width" => 10,
        "shape" => "rectangle"
      }
    ]
  }

  @invalid_attrs %{
    "images" => [
      %{
        "position" => %{
          "x" => 20,
          "y" => 20
        },
        "length" => 10,
        "width" => 10,
        "shape" => "rectangle"
      }
    ]
  }

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
      conn = post(conn, Routes.image_path(conn, :create), @create_attrs)
      response = json_response(conn, 201)
      assert response["message"] == "Canvas generated successfully"
      assert response["status"] == "successful"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.image_path(conn, :create), @invalid_attrs)
      response = json_response(conn, 400)
      assert response["status"] == "failed"
    end
  end
end

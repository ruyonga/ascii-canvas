defmodule AsciiCanvas.CanvasTest do
  use AsciiCanvas.DataCase

  alias AsciiCanvas.Canvas

  describe "images" do
    alias AsciiCanvas.Canvas.Image
    alias AsciiCanvas.Canvas.Art
    @valid_attrs %{url: "some url"}
    @invalid_attrs %{url: nil}

    @valid_art_attrs %{
      "border" => "@",
      "fill" => "-",
      "length" => 10,
      "position" => %{
        "x" => 20,
        "y" => 20
      },
      "shape" => "rectangle",
      "width" => 10
    }

    @invalid_art_attrs %{
      "border" => nil,
      "fill" => nil,
      "length" => 10,
      "position" => nil,
      "shape" => nil,
      "width" => nil,
      "image_id" => nil
    }

    def image_fixture(attrs \\ %{}) do
      {:ok, image} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Canvas.create_image()

      image
    end

    test "list_images/0 returns all images" do
      image = image_fixture()
      assert Canvas.list_images() == [image]
    end

    test "create_image/1 with valid data creates a image" do
      assert {:ok, %Image{} = image} = Canvas.create_image(@valid_attrs)
      assert image.url == "some url"
    end

    test "create_image/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Canvas.create_image(@invalid_attrs)
    end

    test "save art parameter/1 with valid data creates an ascii image shape paramter enter" do
      image = image_fixture()

      param =
        @valid_art_attrs
        |> Map.put("image_id", image.id)

      assert {:ok, %Art{} = art} = Canvas.save_art_work_parameter(param)
      assert art.border == "@"
      assert art.length == 10
    end

    test "save art parameter/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Canvas.create_image(@invalid_art_attrs)
    end
  end
end

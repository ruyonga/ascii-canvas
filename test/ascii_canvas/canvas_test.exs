defmodule AsciiCanvas.CanvasTest do
  use AsciiCanvas.DataCase

  alias AsciiCanvas.Canvas

  describe "images" do
    alias AsciiCanvas.Canvas.Image

    @valid_attrs %{url: "some url"}
    @invalid_attrs %{url: nil}

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
  end
end

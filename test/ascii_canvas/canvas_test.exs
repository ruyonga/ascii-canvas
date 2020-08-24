defmodule AsciiCanvas.CanvasTest do
  use AsciiCanvas.DataCase

  alias AsciiCanvas.Canvas

  describe "images" do
    alias AsciiCanvas.Canvas.Image

    @valid_attrs %{url: "some url"}
    @update_attrs %{ url: "some updated url"}
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

    test "get_image!/1 returns the image with given id" do
      image = image_fixture()
      assert Canvas.get_image!(image.id) == image
    end

    test "create_image/1 with valid data creates a image" do
      assert {:ok, %Image{} = image} = Canvas.create_image(@valid_attrs)
      assert image.url == "some url"
    end

    test "create_image/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Canvas.create_image(@invalid_attrs)
    end

    test "update_image/2 with valid data updates the image" do
      image = image_fixture()
      assert {:ok, %Image{} = image} = Canvas.update_image(image, @update_attrs)
      assert image.url == "some updated url"
    end

    test "update_image/2 with invalid data returns error changeset" do
      image = image_fixture()
      assert {:error, %Ecto.Changeset{}} = Canvas.update_image(image, @invalid_attrs)
      assert image == Canvas.get_image!(image.id)
    end

    test "delete_image/1 deletes the image" do
      image = image_fixture()
      assert {:ok, %Image{}} = Canvas.delete_image(image)
      assert_raise Ecto.NoResultsError, fn -> Canvas.get_image!(image.id) end
    end

    test "change_image/1 returns a image changeset" do
      image = image_fixture()
      assert %Ecto.Changeset{} = Canvas.change_image(image)
    end
  end
end

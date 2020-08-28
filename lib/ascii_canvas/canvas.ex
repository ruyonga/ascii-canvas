defmodule AsciiCanvas.Canvas do
  @moduledoc """
  The Canvas context.
  """

  import Ecto.Query, warn: false
  alias AsciiCanvas.Repo

  alias AsciiCanvas.Canvas.Image
  alias AsciiCanvas.Canvas.Art

  def list_images do
    Repo.all(Image)
  end

  def get_image!(id), do: Repo.get!(Image, id)

  def create_image(attrs \\ %{}) do
    %Image{}
    |> Image.changeset(attrs)
    |> Repo.insert()
  end

  def save_art_work_parameter(attrs \\ %{}) do
    %Art{}
    |> Art.changeset(attrs)
    |> Repo.insert()
  end
end

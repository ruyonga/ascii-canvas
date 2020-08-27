defmodule AsciiCanvas.Canvas.Art do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "art_parameters" do
    field :border, :string
    field :fill, :string
    field :length, :integer
    field :position, :map
    field :shape, :string
    field :width, :integer
    field :image_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(art, attrs) do
    art
    |> cast(attrs, [:position, :length, :width, :border, :fill, :shape])
    |> validate_required([:position, :length, :width, :shape])
  end
end

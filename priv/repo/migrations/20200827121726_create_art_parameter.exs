defmodule AsciiCanvas.Repo.Migrations.CreateArtParameter do
  use Ecto.Migration

  def change do
    create table(:art_parameters, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :position, :map
      add :length, :integer
      add :width, :integer
      add :border, :string
      add :fill, :string
      add :shape, :string
      add :image_id, references(:images, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:art_parameters, [:image_id])
  end
end

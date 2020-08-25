defmodule AsciiCanvas.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :url, :string

      timestamps()
    end
  end
end

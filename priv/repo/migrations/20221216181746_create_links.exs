defmodule Shortr.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :url, :string
      add :slug, :string
      add :hits, :integer, default: 0
    end
  end
end

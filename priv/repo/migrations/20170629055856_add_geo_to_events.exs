defmodule Events.Repo.Migrations.AddGeoToEvents do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :geo, :string
    end
  end
end

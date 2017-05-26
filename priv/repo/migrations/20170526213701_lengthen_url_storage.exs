defmodule Events.Repo.Migrations.LengthenUrlStorage do
  use Ecto.Migration

  def change do
    alter table(:events) do
      modify :url, :text
    end
  end
end

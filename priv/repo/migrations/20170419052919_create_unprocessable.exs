defmodule Events.Repo.Migrations.CreateUnprocessable do
  use Ecto.Migration

  def change do
    create table(:unprocessables) do
      add :params, :map

      timestamps()
    end

  end
end

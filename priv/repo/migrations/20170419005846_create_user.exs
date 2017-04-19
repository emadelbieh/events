defmodule Events.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :subid, :string
      add :context, :map

      timestamps()
    end

  end
end

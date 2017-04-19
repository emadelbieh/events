defmodule Events.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :type, :string
      add :data, :string
      add :data_details, :map
      add :platform, :string
      add :publisherid, :string
      add :subid, :string
      add :date, :datetime
      add :url, :string
      add :uuid, :string

      timestamps()
    end

  end
end

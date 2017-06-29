defmodule Events.Repo.Migrations.ChangeColumnTypeOfDate do
  use Ecto.Migration

  def change do
    alter table(:events) do
      modify :date, :date
    end
  end
end

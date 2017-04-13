defmodule Events.Query do
  use Ecto.Schema
  import Ecto.Changeset

  def embedded_schema do
    field :url
    field :keyword
    field :price
    field :attributes
  end
end

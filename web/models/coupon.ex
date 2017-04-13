defmodule Events.Coupon do
  use Ecto.Schema
  import Ecto.Changeset

  def embedded_schema do
    field :offer_name
    field :deal_type
    field :merchant
    field :network
    field :category
    field :code
    field :rating
  end
end

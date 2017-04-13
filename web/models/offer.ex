defmodule Events.Offer do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :click_attributevalue_url
    field :click_attribute_url
    field :click_category_url
    field :click_offer_url
    field :click_product_url
    field :click_review_url
    field :click_coupon_url
  end
end

defmodule Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :type
    field :data
    field :data_details, :map
    field :platform
    field :publisherid
    field :subid
    field :date
    field :url
    field :uuid
  end

  @event ~w(click view request)
  @valid_platforms ~w(topbar extension visual_search search native)

  def changeset(struct, params) do
    fields = [:type, :data, :data_details, :platform, :publisherid, :subid, :date, :url, :uuid]

    struct
    |> cast(params, fields)
    |> validate_required(fields)
    |> validate_inclusion(:platform, @valid_platforms)
  end
end

defmodule Events.Event do
  use Events.Web, :model

  schema "events" do
    field :type, :string
    field :data, :string
    field :data_details, :map
    field :platform, :string
    field :publisherid, :string
    field :subid, :string
    field :date, Ecto.DateTime
    field :url, :string
    field :uuid, :string

    timestamps()
  end

  @valid_platforms ~w(topbar extension visual_search search native)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:type, :data, :data_details, :platform, :publisherid, :subid, :date, :url, :uuid])
    |> validate_required([:type, :data, :data_details, :platform, :date, :url, :uuid])
    |> validate_inclusion(:platform, @valid_platforms)
  end
end

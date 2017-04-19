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
    |> validate_required([:type, :data, :data_details, :platform, :publisherid, :subid, :date, :url, :uuid])
    |> validate_inclusion(:platform, @valid_platforms)
    |> validate_subid_matches_uuid()
  end

  defp validate_subid_matches_uuid(changeset) do
    subid = get_field(changeset, :subid)
    uuid = get_field(changeset, :uuid)

    case Events.Repo.get_by(Events.User, %{subid: subid, id: uuid}) do
      nil ->
        add_error(changeset, :uuid, "is invalid")
      _ ->
        changeset
    end
  end
end

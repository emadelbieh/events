defmodule Events.User do
  use Events.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}

  schema "users" do
    field :uuid, Ecto.UUID
    field :subid, :string
    field :context, :map

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:uuid, :context])
    |> validate_required([:uuid])
    |> unique_constraint(:uuid)
  end
end

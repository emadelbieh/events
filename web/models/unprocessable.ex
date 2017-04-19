defmodule Events.Unprocessable do
  use Events.Web, :model

  schema "unprocessables" do
    field :params, :map

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:params])
    |> validate_required([:params])
  end
end

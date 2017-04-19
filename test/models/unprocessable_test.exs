defmodule Events.UnprocessableTest do
  use Events.ModelCase

  alias Events.Unprocessable

  @valid_attrs %{params: %{}}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Unprocessable.changeset(%Unprocessable{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Unprocessable.changeset(%Unprocessable{}, @invalid_attrs)
    refute changeset.valid?
  end
end

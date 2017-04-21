defmodule Events.UserTest do
  use Events.ModelCase

  alias Events.User

  @valid_attrs %{context: %{}, uuid: "f97182d5-decb-48c9-acc4-30e77630f48c"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end

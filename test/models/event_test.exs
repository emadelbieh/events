defmodule Events.EventTest do
  use Events.ModelCase

  alias Events.Event

  @valid_attrs %{data: "some content", data_details: %{}, date: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, platform: "visual_search", publisherid: "some content", subid: "DEV", type: "some content", url: "some content"}
  @invalid_attrs %{uuid: "ffe90ab0-76bf-47e4-84dc-c75aab459b54", subid: "DEV"}

  test "changeset with valid attributes" do
    user = Events.Repo.insert!(%Events.User{subid: "DEV"})
    changeset = Event.changeset(%Event{}, Map.merge(@valid_attrs, %{uuid: user.id}))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Event.changeset(%Event{}, @invalid_attrs)
    refute changeset.valid?
  end
end

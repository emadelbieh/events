defmodule Events.EventTest do
  use Events.ModelCase

  alias Events.Event

  @valid_attrs %{data: "some content", data_details: %{}, date: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, platform: "visual_search", publisherid: "some content", subid: "some content", type: "some content", url: "some content", uuid: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Event.changeset(%Event{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Event.changeset(%Event{}, @invalid_attrs)
    refute changeset.valid?
  end
end

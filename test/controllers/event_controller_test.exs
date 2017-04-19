defmodule Events.EventControllerTest do
  use Events.ConnCase

  alias Events.Event
  @valid_attrs %{data: "some content", data_details: %{}, date: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, platform: "visual_search", publisherid: "some content", subid: "some content", type: "some content", url: "some content", uuid: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, event_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    event = Repo.insert! %Event{}
    conn = get conn, event_path(conn, :show, event)
    assert json_response(conn, 200)["data"] == %{"id" => event.id,
      "type" => event.type,
      "data" => event.data,
      "data_details" => event.data_details,
      "platform" => event.platform,
      "publisherid" => event.publisherid,
      "subid" => event.subid,
      "date" => event.date,
      "url" => event.url,
      "uuid" => event.uuid}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, event_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, event_path(conn, :create), @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Event, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, event_path(conn, :create), event: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end
end

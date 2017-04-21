defmodule Events.EventControllerTest do
  use Events.ConnCase, async: false

  alias Events.Event
  @valid_attrs %{data: "some content", data_details: %{}, date: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, platform: "visual_search", publisherid: "1", subid: "DEV", type: "some content", url: "some content", uuid: "some content"}
  @invalid_attrs %{uuid: "ffe90ab0-76bf-47e4-84dc-c75aab459b54", subid: "DEV", data_details: %{}}

  setup %{conn: conn} do
    user = Events.Repo.insert!(%Events.User{uuid: "ffe90ab0-76bf-47e4-84dc-c75aab459b54"})
    {:ok, conn: put_req_header(conn, "accept", "application/json"), user: user}
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

  test "creates and renders resource when data is valid", %{conn: conn, user: user} do
    conn = post conn, event_path(conn, :create), Map.merge(@valid_attrs, %{uuid: user.uuid})
    assert json_response(conn, 201)["success"] == "true"
    assert Repo.get_by(Event, Map.merge(@valid_attrs, %{uuid: user.uuid}))
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, event_path(conn, :create), event: @invalid_attrs
    assert json_response(conn, 201)["success"] == "true"
  end
end

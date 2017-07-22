defmodule Events.EventControllerTest do
  use Events.ConnCase

  alias Events.Event
  @valid_attrs %{data: "some content", data_details: %{geo: "US"}, platform: "visual_search", publisherid: "1", subid: "DEV", type: "some content", url: "some content", uuid: "some content"}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
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
    assert json_response(conn, 201)
  end
end

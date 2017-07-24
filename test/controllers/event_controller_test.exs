defmodule Events.EventControllerTest do
  use Events.ConnCase

  #@valid_attrs %{data: "some content", data_details: %{geo: "US"}, platform: "visual_search", publisherid: "1", subid: "DEV", type: "some content", url: "some content", uuid: "some content"}
  #@invalid_attrs %{uuid: "ffe90ab0-76bf-47e4-84dc-c75aab459b54", subid: "DEV", data_details: %{}}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end
end

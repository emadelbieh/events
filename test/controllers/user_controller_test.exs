defmodule Events.UserControllerTest do
  use Events.ConnCase

  #@valid_attrs %{context: %{}, ip: "8.8.8.8", publisher_id: "1"}
  #@invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end
end

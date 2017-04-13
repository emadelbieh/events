defmodule Events.PageControllerTest do
  use Events.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert json_response(conn, 200) == %{"error" => "unauthorized"}
  end
end

defmodule Events.UserControllerTest do
  use Events.ConnCase

  alias Events.User
  @valid_attrs %{context: %{}, ip: "8.8.8.8", api_key: "12345"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = get conn, user_path(conn, :show, user)
    assert json_response(conn, 200)["data"] == %{
      "uuid" => user.uuid,
      "context" => user.context}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_path(conn, :show, "7488a646-e31f-11e4-aace-600308960662")
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), @valid_attrs
    uuid = json_response(conn, 201)["data"]["uuid"]
    assert uuid
    assert Repo.get_by(User, uuid: uuid)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end
end

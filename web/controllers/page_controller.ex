defmodule Events.PageController do
  use Events.Web, :controller

  def index(conn, _params) do
    json conn, %{error: "unauthorized"}
  end
end

defmodule Events.IdentityController do
  use Events.Web, :controller

  def generate(conn, _params) do
    json(conn, UUID.uuid1())
  end
end

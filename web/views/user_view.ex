defmodule Events.UserView do
  use Events.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, Events.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Events.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{uuid: user.uuid,
      context: user.context}
  end
end

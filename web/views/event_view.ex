defmodule Events.EventView do
  use Events.Web, :view

  def render("index.json", %{events: events}) do
    %{data: render_many(events, Events.EventView, "event.json")}
  end

  def render("show.json", %{event: event}) do
    %{data: render_one(event, Events.EventView, "event.json")}
  end

  def render("show_blank.json", _) do
    %{success: "true"}
  end

  def render("event.json", %{event: event}) do
    %{id: event.id,
      type: event.type,
      data: event.data,
      data_details: event.data_details,
      platform: event.platform,
      publisherid: event.publisherid,
      subid: event.subid,
      date: event.date,
      url: event.url,
      uuid: event.uuid}
  end
end

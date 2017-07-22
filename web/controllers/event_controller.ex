defmodule Events.EventController do
  use Events.Web, :controller

  alias Events.Event
  alias Events.ElasticSearch
  alias Events.ParamsPreprocessor, as: Preprocessor

  def create(conn, event_params) do
    event_params = Preprocessor.prepare(event_params, conn)
    ElasticSearch.create_event(event_params)

    conn
    |> put_status(:created)
    |> json(event_params)
  end

  def show(conn, %{"id" => id}) do
    event = Repo.get!(Event, id)
    render(conn, "show.json", event: event)
  end

  def search(conn, %{"subids" => subids, "start_date" => start_date, "end_date" => end_date}) do
    events = Events.UuidPreprocessor.cache(subids, start_date, end_date)
    json(conn, events)
  end
end

defmodule Events.EventController do
  use Events.Web, :controller

  alias Events.Event
  alias Events.ElasticSearch
  alias Events.ParamsPreprocessor, as: Preprocessor

  def create(conn, event_params) do
    event_params = Preprocessor.prepare(event_params, conn)
    ElasticSearch.create_event(event_params)

    event_params = Map.put(event_params, "date", Ecto.Date.utc())
    changeset = Event.changeset(%Event{}, event_params)

    case Repo.insert(changeset) do
      {:ok, event} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", event_path(conn, :show, event))
        |> render("show.json", event: event)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Events.ChangesetView, "error.json", changeset: changeset)
    end
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

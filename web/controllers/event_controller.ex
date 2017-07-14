defmodule Events.EventController do
  use Events.Web, :controller

  alias Events.Event
  alias Events.{Amplitude, ElasticSearch}
  require Logger

  def index(conn, _params) do
    events = Repo.all(Event)
    render(conn, "index.json", events: events)
  end

  def create(conn, event_params) do
    event_params = if is_binary(event_params["data_details"]) do
      data_details = Poison.decode!(event_params["data_details"])
      Map.put(event_params, "data_details", data_details)
    else
      event_params
    end

    event_params = assign_geo_if_needed(conn, event_params)

    Map.put(event_params, "date", Ecto.Date.utc())

    changeset = Event.changeset(%Event{}, event_params)

    case ElasticSearch.create_event(event_params) do
      {:ok, _result} -> nil
      {:error, error} ->
        Logger.warn "Create event failure: #{inspect error}"
    end

    case Repo.insert(changeset) do
      {:ok, event} ->
        Amplitude.track(event_params)

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

  def assign_geo_if_needed(conn, %{"data_details" => data_details} = event_params) do
    geo = (data_details["geo"] || data_details["country_code"] || data_details["country"])

    geo = case geo do
      [geo] -> geo
      nil -> nil
      [] -> nil
      geo -> geo
    end

    if geo do
      Map.put(event_params, "geo", geo)
    else
      Map.put(event_params, "geo", get_country(conn))
    end
  end

  def assign_geo_if_needed(_, event_params) do
    event_params
  end

  def show(conn, %{"id" => id}) do
    event = Repo.get!(Event, id)
    render(conn, "show.json", event: event)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Repo.get!(Event, id)
    changeset = Event.changeset(event, event_params)

    case Repo.update(changeset) do
      {:ok, event} ->
        render(conn, "show.json", event: event)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Events.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Repo.get!(Event, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(event)

    send_resp(conn, :no_content, "")
  end

  def search(conn, %{"subids" => subids, "start_date" => start_date, "end_date" => end_date}) do
    events = Events.UuidPreprocessor.cache(subids, start_date, end_date)
    json(conn, events)
    #render(conn, "index.json", events: events)
  end

  def get_country(conn) do
    case get_req_header(conn, "cf-ipcountry") do
      [] -> nil
      [geo] -> geo
      geo -> geo
    end
  end
end

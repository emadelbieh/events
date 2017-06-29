defmodule Events.EventController do
  use Events.Web, :controller

  alias Events.Event
  alias Events.Amplitude

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

    date = Ecto.Date.cast(event_params["date"])
    Map.put(event_params, "date", date)

    changeset = Event.changeset(%Event{}, event_params)

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
    events = Repo.all(from e in Event,
      where: e.subid in ^subids,
      where: fragment("? >= ? and ? < ?",
        e.date, type(^start_date,Ecto.Date),
        e.date, type(^end_date, Ecto.Date)))

    events = events
    |> Enum.map(fn event ->
      %{
        "date" => event.date,
        "uuid" => event.uuid,
        "geo" => (event.data_details["geo"] || event.data_details["country_code"] || event.data_details["country"])
      }
    end)
    |> process()

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

  defp process(events) do
    events
    |> Stream.map(&to_internal/1)
    |> Enum.uniq()
    |> Enum.reduce(%{}, &merge_date/2)
  end

  defp merge_date(element, accumulator) do
    case accumulator[element.date] do
      nil -> Map.put(accumulator, element.date, merge_geo(element, %{}))
      map -> Map.put(accumulator, element.date, merge_geo(element, map))
    end
  end

  defp merge_geo(element, accumulator) do
    case accumulator[element.geo] do
      nil -> Map.put(accumulator, element.geo, %{"dau" => 1})
      %{"dau" => dau} -> Map.put(accumulator, element.geo, %{"dau" => dau+1})
    end
  end

  defp to_internal(event) do
    %{}
    |> Map.put(:uuid, get_uuid(event))
    |> Map.put(:date, get_date(event))
    |> Map.put(:geo, get_geo(event))
  end

  defp get_uuid(event) do
    event["uuid"]
  end

  defp get_date(event) do
    event["date"]
    |> Date.to_string()
  end

  defp get_geo(event) do
    case event["geo"] do
      nil -> nil
      [geo|_] -> String.upcase(geo)
      geo -> String.upcase(geo)
    end
  end
end

defmodule Events.EventController do
  use Events.Web, :controller

  alias Events.Event
  alias Events.Unprocessable

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

    changeset = Event.changeset(%Event{}, event_params)

    case Repo.insert(changeset) do
      {:ok, event} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", event_path(conn, :show, event))
        |> render("show.json", event: event)
      {:error, changeset} ->
        #unprocessable_changeset = Unprocessable.changeset(%Unprocessable{}, %{params: event_params})
        #Repo.insert(unprocessable_changeset)
        #conn
        #|> put_status(:created)
        #|> render("show_blank.json", %{})
        conn
        |> put_status(:unprocessable_entity)
        |> render(Events.ChangesetView, "error.json", changeset: changeset)
    end
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

  def search(conn, %{"subids" => subids}) do
    events = Repo.all(from e in Event, where: e.subid in ^subids)
    render(conn, "index.json", events: events)
  end
end

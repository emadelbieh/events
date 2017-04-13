defmodule Events.EventController do
  use Events.Web, :controller

  alias Events.Event
  alias Events.ErrorFormatter

  def create(conn, params) do
    changeset = Event.changeset(%Event{}, params)

    if changeset.valid? do
      event = Ecto.Changeset.apply_changes(changeset)
      json conn, %{success: event}
    else
      json conn, %{errors: ErrorFormatter.format(changeset.errors)}
    end
  end
end

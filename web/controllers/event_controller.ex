defmodule Events.EventController do
  use Events.Web, :controller

  alias Events.Event

  def create(conn, params) do
    changeset = Event.changeset(%Event{}, params)

    if changeset.valid? do
      event = Ecto.Changeset.apply_changes(changeset)
      json conn, %{success: event}
    else
      IO.inspect changeset
      errors = Enum.map(changeset.errors, fn {field, detail} ->
        %{
          field: field,
          error: render_detail(detail)
        }
      end)
      json conn, %{errors: errors}
    end
  end

  defp render_detail({message, values}) do
    Enum.reduce values, message, fn {k, v}, acc ->
      String.replace(acc, "%{#{k}}", to_string(v))
    end
  end

  defp render_detail(message) do
    message
  end
end

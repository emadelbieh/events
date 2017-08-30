defmodule Events.LogCleaner do
  def get_log_filename({date, {hour, _minute, _second}}) do
    iso8601_date =
      date
      |> Date.from_erl!()
      |> Date.to_iso8601()

    "events_#{iso8601_date}_#{hour}.log"
  end

  @doc """
  Call this without an argument. The parameter is there to make it testable.
  """
  def delete_log_previous_hour(datetime \\ Timex.now()) do
    result = datetime
    |> Timex.to_erl()
    |> Events.TimeUtils.previous_hour()
    |> get_log_filename()
    |> File.rm()

    case result do
      :ok ->
        Events.Slack.send_message "[Events] Successfully deleted log for the previous hour"
      {:error, error} ->
        Events.Slack.send_message "[Events] Error deleting log: #{error}"
    end

    result
  end
end

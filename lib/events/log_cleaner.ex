defmodule Events.LogCleaner do
  def get_log_filename({date, {hour, _minute, _second}}) do
    iso8601_date =
      date
      |> Date.from_erl!()
      |> Date.to_iso8601()

    "events_#{iso8601_date}_#{hour}.log"
  end

  def delete_log_previous_hour(datetime \\ Timex.now()) do
    datetime
    |> Timex.to_erl()
    |> Events.TimeUtils.previous_hour()
    |> get_log_filename()
    |> File.rm()
  end
end

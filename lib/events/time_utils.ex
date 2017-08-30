defmodule Events.TimeUtils do
  def previous_hour(date, time) do
    {{year, month, day}, {hour, _minute, _second}} =
      {date, time}
      |> Timex.to_datetime
      |> Timex.shift(hours: -1)
      |> Timex.to_erl

    {year, month, day, hour}
  end
end

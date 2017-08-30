defmodule Events.TimeUtils do
  def previous_hour(erl_datetime) do
    erl_datetime
    |> Timex.to_datetime
    |> Timex.shift(hours: -1)
    |> Timex.to_erl
  end
end

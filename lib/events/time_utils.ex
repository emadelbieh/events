defmodule Events.TimeUtils do
  def previous_hour(date, time) do
    {year, month, day} = date
    {hour, _minute, _second} = time
    
    case hour do
      0 ->
        case day do
          1 ->
            datetime = {date, time}
            {{year, month, day}, _} =
              Timex.shift(datetime, days: -1)
              |> Timex.to_erl
              {year, month, day, 23}
          _ ->
            {year, month, day-1, 23}
        end
      hour ->
        {year, month, day, hour-1}
    end
  end
end

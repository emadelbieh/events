defmodule Events.LogCleaner do
  def delete_file_from_previous_hour do
    {{year, month, day} = date, {hour, minute, second} = time} = Timex.now |> Timex.to_erl
    {year, month, day, hour} = Events.TimeUtils.previous_hour

    date = {year, month, day}
    {:ok, date} = Date.from_erl(date)
    date = date |> Date.to_iso8601

    File.rm("events_#{date}_#{hour}.log")
  end
end

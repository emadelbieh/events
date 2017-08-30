defmodule Events.LogCleanerTest do
  use ExUnit.Case

  alias Events.LogCleaner, as: L

  test "get_log_filename returns filename for the {date, time} given" do
    date = {2017, 1, 1}
    time = {12, 20, 34}
    assert L.get_log_filename({date, time}) == "events_2017-01-01_12.log"
  end

  test "delete_log_previous_hour" do
    assert File.rm(dummy_filename()) == {:error, :enoent}
    create_dummy_file()
    result = dummy_datetime_erl() |> L.delete_log_previous_hour()
    assert result == :ok
  end

  defp create_dummy_file() do
    file = dummy_filename() |> File.open([:write])
    IO.binwrite(file, "dummy log")
    File.close(file)
  end

  defp dummy_filename do
    "events_2016-12-31_23.log"
  end

  defp dummy_datetime_erl do
    {{2017,1,1}, {0,5,34}}
  end
end

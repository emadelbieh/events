defmodule Events.TimeUtilsTest do
  use ExUnit.Case

  alias Events.TimeUtils, as: T

  test "previous_hour returns the date and hour preceding the current time" do
    erl_date = {2017, 8, 29}
    erl_time = {12, 27, 57}
    assert T.previous_hour({erl_date, erl_time}) == {{2017, 8, 29}, {11, 27, 57}}
  end

  test "previous_hour returns previous day when necessary" do
    erl_date = {2017, 8, 29}
    erl_time = {0, 27, 57}
    assert T.previous_hour({erl_date, erl_time}) == {{2017, 8, 28}, {23, 27, 57}}
  end

  test "previous_hour returns previous month when necessary" do
    erl_date = {2017, 8, 1}
    erl_time = {0, 27, 57}
    assert T.previous_hour({erl_date, erl_time}) == {{2017, 7, 31}, {23, 27, 57}}

    erl_date = {2017, 3, 1}
    erl_time = {0, 27, 57}
    assert T.previous_hour({erl_date, erl_time}) == {{2017, 2, 28}, {23, 27, 57}}
  end

  test "previous_hour returns previous year when necessary" do
    erl_date = {2017, 1, 1}
    erl_time = {0, 27, 57}
    assert T.previous_hour({erl_date, erl_time}) == {{2016, 12, 31}, {23, 27, 57}}
  end
end

defmodule Reporting.DateUtils do
  @january 1
  @december 12

  def beginning_of_month do
    {year, month, _day} = today()
    {year, month, 1}
  end

  def get_next_month(date) do
    case date do
      {year, @december, day} -> {year+1, @january, day}
      {year, month, day} -> {year, month+1, day}
    end
  end

  def pad(num) do
    num
    |> Integer.to_string()
    |> String.rjust(2, ?0)
  end

  def today do
    Date.utc_today |> Date.to_erl
  end
end

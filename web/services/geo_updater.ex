defmodule Events.GeoUpdater do
  import Ecto.Query
  
  alias Events.{Repo, Event}

  def dates(month, days) do
    Enum.map(28..days, fn day ->
      Ecto.Date.cast!({2017, month, day})
      |> Ecto.Date.to_string
    end)
  end

  def get_geo(%{data_details: data_details} = event) do
    case (data_details["geo"] || data_details["country_code"] || data_details["country"]) do
      [geo] -> geo
      nil -> nil
      [] -> nil
      geo -> geo
    end
  end

  def get_geo(_) do
    nil
  end

  def update(month \\ 6, days \\ 30) do
    Enum.each(dates(month, days), fn date ->
      IO.puts("Updating #{date}")
      {:ok, datetime1, _} = DateTime.from_iso8601("#{date}T06:00:00Z")
      {:ok, datetime2, _} = DateTime.from_iso8601("#{date}T09:00:00Z")
      IO.inspect Repo.all(from e in Event, where: e.date == ^date and e.inserted_at >= ^datetime1 and e.inserted_at < ^datetime2, select: count(e.id))
      Repo.all(from e in Event, where: e.date == ^date and e.inserted_at >= ^datetime1 and e.inserted_at < ^datetime2)
      |> Enum.each(fn event ->
        IO.write(".")
        geo = get_geo(event)
        changeset = Event.changeset(event, %{geo: geo})
        Repo.update!(changeset)
      end)
    end)
  end

end

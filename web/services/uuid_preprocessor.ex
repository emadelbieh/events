defmodule Events.UuidPreprocessor do
  alias Events.{Repo, Event}

  import Ecto.Query

  def cache(subids, start_date, end_date) when is_list(subids) do
    subids
    |> query(start_date, end_date)
    |> process()
    |> write_to_file(subids)
  end

  def cache(_, _, _) do
    IO.puts("Expected argument to be a list")
  end

  def query(subids, start_date, end_date) do
    Repo.all(from e in Event,
      where: e.subid in ^subids
        and e.date >= ^Ecto.Date.cast!(start_date)
        and e.date < ^Ecto.Date.cast!(end_date),
      group_by: [e.date, e.subid, e.geo],
      select: {e.subid, e.date, e.geo, count(e.uuid, :distinct)})
  end

  def process(result_set) do
    Enum.reduce(result_set, %{}, fn data, acc ->
      {_subid, date, geo, dau} = data
      date = Ecto.Date.to_string(date)
      
      if acc[date] do
        value = Map.put(acc[date], geo, dau)
        Map.put(acc, date, value)
      else
        Map.put(acc, date, %{geo => dau})
      end
    end)
  end
  
  def write_to_file(result_set, subids) do
    filename = create_filename(subids)
    case File.open(filename, [:write]) do
      {:ok, file} ->
        IO.binwrite file, Poison.encode!(result_set)
      _ ->
        IO.puts("File not saved")
    end
  end

  def load_from_file(subids) do
    filename = create_filename(subids)
    case File.read(filename) do
      {:ok, data} -> Poison.decode!(data)
      _ -> %{}
    end
  end

  def create_filename(subids) do
    prefix = subids
    |> Enum.join("_")
    |> String.downcase()

    prefix <> "_dau_data"
  end
end

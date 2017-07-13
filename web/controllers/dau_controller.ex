defmodule Events.DauController do
  use Events.Web, :controller

  alias Events.Event

  def search(conn, %{"subid" => subid, "date" => date, "geo" => geo}) do
    [dau] = Repo.all(from e in Event,
      select: count(e.uuid, :distinct),
      where: e.subid == ^subid
      and e.date == ^date
      and e.geo == ^geo)

    json(conn, %{subid: subid, date: date, geo: geo, dau: dau})
  end

  def search(conn, _params) do
    json(conn, %{error: "wrong params"})
  end
end

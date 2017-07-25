defmodule Events.DauController do
  use Events.Web, :controller

  def search(conn, %{"subid" => subid, "date" => date, "geo" => geo}) do
    dau = Events.DauFetcher.fetch(date, subid, geo)
    json(conn, %{subid: subid, date: date, geo: geo, dau: dau})
  end

  def search(conn, _params) do
    json(conn, %{error: "wrong parameters"})
  end
end

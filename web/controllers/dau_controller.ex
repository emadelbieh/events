defmodule Events.DauController do
  use Events.Web, :controller

  alias Events.ElasticSearch, as: ES

  def search(conn, %{"subid" => subid, "date" => date, "geo" => geo}) do
    case ES.search(date, subid, geo) do
      {:ok, %HTTPoison.Response{body: data}} ->
        data = Poison.decode!(data)

        dau = if data["error"] do
          0
        else
          dau = data["aggregations"]["distinct_uuid"]["value"]
        end

        json(conn, %{subid: subid, date: date, geo: geo, dau: dau})
      _ ->
        json(conn, %{error: "error retrieving dau"})
    end
  end

  def search(conn, _params) do
    json(conn, %{error: "wrong parameters"})
  end
end

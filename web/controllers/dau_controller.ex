defmodule Events.DauController do
  use Events.Web, :controller

  alias Events.ElasticSearchGateway, as: Gateway

  def search(conn, %{"subid" => subid, "date" => date, "geo" => geo}) do
    params = Poison.encode!(search_params(subid, geo))
    dau = fetch(date, params)
    json(conn, %{subid: subid, date: date, geo: geo, dau: dau})
  end

  def search(conn, _params) do
    json(conn, %{error: "wrong parameters"})
  end

  defp fetch(date, params) do
    case Gateway.search(date, params) do
      {:ok, %HTTPoison.Response{body: data}} ->
        data = Poison.decode!(data)
        IO.inspect(data)
        data["aggregations"]["distinct_uuid"]["value"]
      _ ->
        :error
    end
  end

  defp search_params(subid, geo) do
    %{
      size: 0, query: %{ bool: %{ must: [
            %{ term: %{ subid: subid } },
            %{ term: %{ geo: geo } }
      ]}},
      aggs: %{
        distinct_uuid: %{
          cardinality: %{ field: "uuid" }
        }
      }
    }
  end
end

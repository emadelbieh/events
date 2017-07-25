defmodule Events.DauFetcher do
  alias Events.ElasticSearchGateway, as: Gateway

  def fetch(date, subid, geo) do
    case Gateway.search(date, Poison.encode!(search_params(subid, geo))) do
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
      size: 0,
      query: %{
        bool: %{
          must: [
            %{ term: %{ subid: subid } },
            %{ term: %{ geo: geo } }
          ]
        }
      },
      aggs: %{
        distinct_uuid: %{
          cardinality: %{ field: "uuid" }
        }
      }
    }
  end
end

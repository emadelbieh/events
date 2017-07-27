defmodule Events.ElasticSearchGateway do
  alias Events.ElasticSearch, as: ES

  @elastic_search_server "https://5e6940f9f653fa78fb2d5813e6ed33db.us-east-1.aws.found.io:9243"

  def search(date \\ nil, params) do
    index_pattern = create_index_pattern(date)
    ES.request("post", get_search_url(index_pattern), params)
  end

  def get_search_url(index_pattern) do
    "#{@elastic_search_server}/#{index_pattern}/event/_search"
  end

  def create_index_pattern(nil) do
    "events-*"
  end

  @doc """
  Creates an index pattern based off a date string in yyyy-mm-dd format
  """
  def create_index_pattern(date) do
    [yyyy, mm, dd] = String.split(date, "-")
    "events-#{yyyy}#{mm}#{dd}"
  end
end

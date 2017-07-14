defmodule Events.ElasticSearch do
  alias HTTPoison, as: HTTP

  @doc_type "event"

  def create_event(data) do
    timestamp = Timex.now() |> Timex.format!("{ISO:Extended}")
    data = Map.put(data, :date, timestamp) |> Poison.encode!
    url = Path.join([url(), index_name(), @doc_type])
    request :post, url, data
  end

  def create_event!(data) do
    case create_event(data) do
      {:ok, result} -> result
      {:error, error} -> raise "Error when creating event: #{error.reason}"
    end
  end

  def request(method, url, data, headers \\ [], opts \\ []) do
    headers = [[{"Content-Type", "application/json"}] | headers]
    opts = Keyword.put opts, :basic_auth, basic_auth()
    HTTP.request method, url, data, headers, opts
  end

  def index_name() do
    timestamp = Timex.now()
    |> Timex.format!("{YYYY}{0M}{0D}")
    "events-#{timestamp}"
  end

  def url() do
    Application.get_env(:events, Events.ElasticSearch)[:url]
  end

  def basic_auth() do
    Application.get_env(:events, Events.ElasticSearch)[:basic_auth]
  end
end

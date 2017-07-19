defmodule Events.ElasticSearch do
  alias HTTPoison, as: HTTP
  require Logger

  @doc_type "event"

  @event_mapping %{
    properties: %{
      type: "keyword",
      data: "keyword",
      platform: "keyword",
      publisherid: "keyword",
      subid: "keyword",
      date: "date",
      url: "keyword",
      uuid: "keyword",
      geo: "keyword"
    }
  }

  def put_event_mapping(index_name) do
    url = Path.join([url(), index_name, "_mapping", @doc_type])
    body = Poison.encode!(@event_mapping)
    request :put, url, body
  end

  def create_event(data) do
    timestamp = Timex.now() |> Timex.format!("{ISO:Extended}")
    body = Map.put(data, :date, timestamp) |> Poison.encode!
    url = Path.join([url(), index_name(), @doc_type])

    Task.start fn ->
      case request :post, url, body do
        {:ok, _} ->
          Logger.info "Event #{data["type"]} logged."
        {:error, reason} ->
          Logger.warn "Error creating event #{data["type"]} with reason #{inspect reason}"
      end
    end
  end

  def request(method, url, data, headers \\ [], opts \\ []) do
    headers = [{"Content-Type", "application/json"} | headers]
    opts = Keyword.merge(opts, request_opts())
    HTTP.request method, url, data, headers, opts
  end

  defp request_opts() do
    if auth = basic_auth() do
      [hackney: [basic_auth: auth], timeout: 20000, recv_timeout: 20000]
    else
      [timeout: 20000, recv_timeout: 20000]
    end
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

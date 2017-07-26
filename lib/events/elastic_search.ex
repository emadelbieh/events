defmodule Events.ElasticSearch do
  alias HTTPoison, as: HTTP
  require Logger

  @doc_type "event"

  @event_mapping %{
    properties: %{
      type: %{type: "keyword"},
      data: %{type: "keyword"},
      platform: %{type: "keyword"},
      publisherid: %{type: "keyword"},
      subid: %{type: "keyword"},
      date: %{type: "date"},
      url: %{type: "text"},
      uuid: %{type: "keyword"},
      geo: %{type: "keyword"},
      data_details: %{
        properties: %{
          keyword: %{type: "keyword"},
          img: %{type: "text"},
          price: %{
            type: "scaled_float",
            scaling_factor: 100
          },
          value: %{type: "keyword"},
          domain: %{type: "keyword"},
          ip_address: %{type: "keyword"}
        }
      }
    }
  }

  @doc """
  For creating a mapping on an index. Refer to
  https://www.elastic.co/guide/en/elasticsearch/reference/5.x/indices-create-index.html#create-index-settings
  """
  def create_event_index(time \\ nil) do
    url = Path.join([url(), index_name(time)])
    body = %{mappings: %{event: @event_mapping}} |> Poison.encode!
    request :put, url, body
  end

  @doc """
  https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-put-mapping.html
  """
  def put_event_mapping(time \\ nil) do
    url = Path.join([url(), index_name(time), "_mapping", @doc_type])
    body = Poison.encode!(@event_mapping)
    request :put, url, body
  end

  def create_event(data) do
    timestamp = Timex.now() |> Timex.format!("{ISO:Extended}")
    body = Map.put(data, "date", timestamp) |> Poison.encode!
    url = Path.join([url(), index_name(), @doc_type])

    Task.start fn ->
      case request :post, url, body do
        {:ok, %HTTPoison.Response{body: body, status_code: 400}} ->
          body = Poison.decode!(body)
          Logger.warn "Error in creating event: #{body["error"]["reason"]}"
        {:ok, _} ->
          Logger.info "Event #{data["data"]} #{data["type"]} logged."
        {:error, reason} ->
          Logger.warn "Error creating event #{data["data"]} #{data["type"]} with reason #{inspect reason}"
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

  def index_name(time \\ nil) do
    timestamp = (time || Timex.now()) |> Timex.format!("{YYYY}{0M}{0D}")
    "events-#{timestamp}"
  end

  def url() do
    Application.get_env(:events, Events.ElasticSearch)[:url]
  end

  def basic_auth() do
    Application.get_env(:events, Events.ElasticSearch)[:basic_auth]
  end
end

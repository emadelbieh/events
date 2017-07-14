defmodule Events.ElasticSearch do
  alias Elastix.{Document}

  @doc_type "event"

  def index_name() do
    timestamp = Timex.now()
    |> Timex.format!("{YYYY}{0M}{0D}")
    "events-#{timestamp}"
  end

  def url() do
    Application.get_env(:events, Events.ElasticSearch)[:url]
  end

  def create_event(data) do
    timestamp = Timex.now() |> Timex.format!("{ISO:Extended}")
    data = Map.put(data, :date, timestamp)
    Document.index_new(url(), index_name(), @doc_type, data)
  end

  def create_event!(data) do
    case create_event(data) do
      {:ok, result} -> result
      {:error, error} -> raise "Error when creating event: #{error.reason}"
    end
  end
end

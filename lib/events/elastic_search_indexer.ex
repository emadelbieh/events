defmodule Events.ElasticSearchIndexer do
  @moduledoc """
  This server sends a put mapping request for event type every 24 hours.
  The put mapping requests sent are for the events index for today and
  the next day. This is to ensure that we do not rely on ElasticSearch's
  dynamic mapping and that a mapping exists for `event` type on an index
  before a document is stored there.
  """

  use GenServer
  alias Events.ElasticSearch
  require Logger

  @day_in_ms 24 * 60 * 60 * 1000

  def start_link(opts \\ []) do
    GenServer.start_link __MODULE__, opts, name: __MODULE__
  end

  def init(state) do
    send self(), :map_events_index
    {:ok, state}
  end

  def handle_info(:map_events_index, state) do
    interval = Application.get_env(:events, :events_indexing_interval) || @day_in_ms
    Logger.debug "Interval for creating indices at #{interval}ms"
    Process.send_after self(), :map_events_index, interval

    Logger.debug "Indices for today's and tomorrow's events are being created"
    ElasticSearch.create_event_index()

    Timex.now()
    |> Timex.add(Timex.Duration.from_days(1))
    |> ElasticSearch.create_event_index()

    {:noreply, state}
  end
end

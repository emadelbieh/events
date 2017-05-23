defmodule Events.Amplitude do
  @moduledoc """
  Amplitude.com API gateway.

  ## References
  - [Amplitude HTTP API reference](https://amplitude.zendesk.com/hc/en-us/articles/204771828)
  - [Property list as of v1.1.0](https://github.com/blackswan-ventures/apientry/issues/65#issuecomment-233222630)
  """

  @amplitude Application.get_env(:events, :amplitude) |> Enum.into(%{})

  def track(%{uuid: user_id, data: event_type, data_details: event_properties} = data) do
    params = %{
      user_id: user_id,
      event_type: event_type,
      event_properties: Enum.into(event_properties, Map.delete(data, :data_details))
    }
    send_request(params)
  end

  def send_request(params) do
    headers = %{"Content-Type": "application/json"}
    data = {:form, [api_key: @amplitude.api_key, event: Poison.encode!(params)]}

    Task.start fn ->
      case HTTPoison.post(@amplitude.url, data, headers) do
        {:ok, _} ->
          IO.puts "Event tracked to Amplitude."
        {:error, reason} ->
          IO.puts("Amplitude error: #{IO.inspect(reason)}")
      end
    end
  end
end

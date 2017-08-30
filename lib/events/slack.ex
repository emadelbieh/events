defmodule Events.Slack do
  @endpoint "https://hooks.slack.com/services/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"
  alias Events.HTTP

  def send_message(message) do
    payload = ~s({"text" : "#{message}"})
    HTTP.post @endpoint, payload
  end
end


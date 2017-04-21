defmodule Events.UUIDGenerator do
  def generate(user_ip, publisher_api_key) do
    UUID.uuid5(:url, "#{user_ip}/#{publisher_api_key}")
  end
end

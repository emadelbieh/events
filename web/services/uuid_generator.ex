defmodule Events.UUIDGenerator do
  def generate(user_ip, publisher_id) do
    UUID.uuid5(:url, "#{user_ip}/#{publisher_id}")
  end
end

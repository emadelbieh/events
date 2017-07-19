defmodule Events.UUIDGenerator do
  def generate(fingerprint, publisher_id) do
    UUID.uuid5(:oid, "#{fingerprint}/#{publisher_id}")
  end
end

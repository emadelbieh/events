defmodule Events.LogUploader do
  alias ExAws.S3

  def upload_log do
    date = Date.utc_today |> Date.to_iso8601
    {hour, _m, _s} = Time.utc_now |> Time.to_erl

    s3_filename = "events_#{date}_#{hour}.log"
    S3.put_object("events-extra-logs", s3_filename, File.read!(s3_filename))
  end
end

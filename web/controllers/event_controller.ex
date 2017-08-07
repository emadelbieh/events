defmodule Events.EventController do
  use Events.Web, :controller

  alias Events.ElasticSearch
  alias Events.ParamsPreprocessor, as: Preprocessor

  def create(conn, %{"type" => "hover"} = event_params) do
    params = Poison.encode!(event_params)

    date = Date.utc_today |> Date.to_iso8601
    {hour, _m, _s} = Time.utc_now |> Time.to_erl

    file = File.open("events_#{date}_#{hour}.log", [:append])
    IO.binwrite(file, "#{params}\n")
    File.close(file)

    conn
    |> json(event_params)
  end

  def create(conn, event_params) do
    event_params = Preprocessor.prepare(event_params, conn)
    ElasticSearch.create_event(event_params)

    conn
    |> put_status(:created)
    |> json(event_params)
  end
end

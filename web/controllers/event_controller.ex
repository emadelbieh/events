defmodule Events.EventController do
  use Events.Web, :controller

  alias Events.ElasticSearch
  alias Events.ParamsPreprocessor, as: Preprocessor

  def create(conn, event_params) do
    event_params = Preprocessor.prepare(event_params, conn)
    ElasticSearch.create_event(event_params)

    conn
    |> put_status(:created)
    |> json(event_params)
  end
end

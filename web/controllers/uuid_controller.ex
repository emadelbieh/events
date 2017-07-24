defmodule Events.UUIDController do
  use Events.Web, :controller

  def get_ip_address(conn) do
    case get_req_header(conn, "cf-connecting-ip") do
      [] -> nil
      [ip] -> ip
      ip -> ip
    end
  end

  def show(conn, %{"fingerprint" => fingerprint, "publisher_id" => publisher_id}) do
    uuid = Events.UUIDGenerator.generate(fingerprint, publisher_id)

    conn
    |> put_status(:ok)
    |> json(%{data: %{
        "uuid" => uuid,
        "context" => %{fingerprint: fingerprint, publisher_id: publisher_id}
      }})
  end

  def show(conn, %{"ip" => ip, "publisher_id" => publisher_id}) do
    show(conn, %{"fingerprint" => ip, "publisher_id" => publisher_id})
  end

  def show(conn, %{"publisher_id" => publisher_id}) do
    ip = get_ip_address(conn)
    show(conn, %{"fingerprint" => ip, "publisher_id" => publisher_id})
  end

  def show(conn, _) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{error: "invalid parameters"})
  end
end

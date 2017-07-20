defmodule Events.ParamsPreprocessor do
  def prepare(params, conn) do
    params
    |> normalize()
    |> assign_geo(conn)
  end

  defp normalize(%{"data_details" => data_details} = params) when is_binary(data_details) do
    Map.put(params, "data_details", Poison.decode!(data_details))
  end

  defp normalize(params) do
    params
  end

  defp assign_geo(%{"data_details" => %{"geo" => geo}} = params, _conn) do
    Map.put(params, "geo", get_value(geo))
  end

  defp assign_geo(%{"data_details" => %{"country_code" => geo}} = params, _conn) do
    Map.put(params, "geo", get_value(geo))
  end

  defp assign_geo(%{"data_details" => %{"country" => geo}} = params, _conn) do
    Map.put(params, "geo", get_value(geo))
  end

  defp assign_geo(params, conn) do
    Map.put(params, "geo", get_value(get_country(conn)))
  end

  defp get_value(geo) do
    case geo do
      [geo] -> geo
      nil -> nil
      [] -> nil
      geo -> geo
    end
  end

  defp get_country(conn) do
    Plug.Conn.get_req_header(conn, "cf-ipcountry")
  end
end

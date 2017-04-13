defmodule Events.ErrorFormatter do
  def format(errors) do
    Enum.map(errors, fn {field, detail} ->
      %{
        field: field,
        error: render_detail(detail)
      }
    end)
  end

  defp render_detail({message, values}) do
    Enum.reduce values, message, fn {k, v}, acc ->
      String.replace(acc, "%{#{k}}", to_string(v))
    end
  end

  defp render_detail(message) do
    message
  end
end

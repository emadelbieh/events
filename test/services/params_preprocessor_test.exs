defmodule Events.ParamsPreprocessorTest do
  use ExUnit.Case
  
  alias Events.ParamsPreprocessor, as: Preprocessor

  test "prepare converts data_details to map" do
    params = %{"data_details" => "{\"geo\":\"US\"}"}
    params = Preprocessor.prepare(params, %Plug.Conn{})
    assert(params["data_details"] == %{"geo" => "US"})
  end

  test "prepare assigns geo from known sources" do
    params = %{"data_details" => %{"geo" => "DE"}}
    params = Preprocessor.prepare(params, %Plug.Conn{})
    assert(params["geo"] == "DE")

    params = %{"data_details" => %{"country_code" => "PH"}}
    params = Preprocessor.prepare(params, %Plug.Conn{})
    assert(params["geo"] == "PH")

    params = %{"data_details" => %{"country" => "FR"}}
    params = Preprocessor.prepare(params, %Plug.Conn{})
    assert(params["geo"] == "FR")
  end

  test "prepare assigns geo from cloudflare request headers as last resort" do
    conn = Plug.Conn.put_req_header(%Plug.Conn{}, "cf-ipcountry", "AU")
    params = Preprocessor.prepare(%{}, conn)
    assert(params["geo"] == "AU")
  end
end

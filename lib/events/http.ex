defmodule Events.HTTP do

  for method <- [:get, :post, :put, :patch, :delete] do
    def unquote(method)(url, data \\ [], headers \\ [], opts \\ []) do
      opts = Keyword.merge(opts, [timeout: timeout(), recv_timeout: timeout()])
      apply(HTTPoison, :request, [unquote(method), url, data, headers, opts])
    end
  end

  def timeout() do
    50000
  end
end


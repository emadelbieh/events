use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or you later on).
config :events, Events.Endpoint,
  secret_key_base: "Lawi1hanahE8RyoKku/rWHN9fzcyAkkFuRGZMtJhR8AtD6O0oJJRuHNANxNMM+yz"

config :events, Events.ElasticSearch,
  url: "https://search-events-6gjxg6bh7ccyopna6sva7mz4l4.us-east-1.es.amazonaws.com",
  basic_auth: {"elastic", "zA1Sm36snXyGbe4W2Y8k1SWR"}

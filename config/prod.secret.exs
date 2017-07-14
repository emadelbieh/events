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
  url: "https://5e6940f9f653fa78fb2d5813e6ed33db.us-east-1.aws.found.io:9243",
  basic_auth: {"elastic", "zA1Sm36snXyGbe4W2Y8k1SWR"}

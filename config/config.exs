# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :events, Events.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "H9quiJdJk9xQA4efj6przRPRHm9Y1FGtsVvGGHGT4zc3RfWN7LX2K/9b8sMuYqCr",
  render_errors: [view: Events.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Events.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :events, :amplitude,
  url: "https://api.amplitude.com/httpapi",
  app_id: "151574",
  api_key: "c1d3d7723afd6d2d595d7fe60837193d",
  secret_key: "a978ce4186ee60c202079ef56274222e"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :events, Events.ElasticSearch,
  url: "http://localhost:9200"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

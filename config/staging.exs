use Mix.Config

config :events, Events.Endpoint,
  http: [port: 3000],
  url: [
    host: "events-staging.us-east-1.elasticbeanstalk.com",
    port: 80
  ],
  server: true,
  secret_key_base: "GDTc3KLGl6CaS39mkyn7RPPdf44DwAozWkqMyTy5Tdwk30VUH0HlJNUCY1CV2TwN"

config :logger, level: :info

config :events, Events.ElasticSearch,
  url: "https://localhost:9200"

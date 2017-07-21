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

config :events, Events.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: "postgres://events:vcZzX1iTY97t@events-staging.c1snflmeflqw.us-east-1.rds.amazonaws.com:5432/events_staging",
  pool_size: 10,
  ssl: true,
  timeout: 300*1000

config :events, Events.ElasticSearch,
  url: "https://localhost:9200"

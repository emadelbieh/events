use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :events, Events.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

database_url = System.get_env("DATABASE_URL") || "postgres://postgres:postgres@localhost/events_test"

# Configure your database
config :events, Events.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: database_url,
  pool: Ecto.Adapters.SQL.Sandbox

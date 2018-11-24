use Mix.Config

# Configure your database
config :loca, Loca.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "loca_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

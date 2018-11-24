# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :loca_web,
  namespace: LocaWeb,
  ecto_repos: [Loca.Repo]

# Configures the endpoint
config :loca_web, LocaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "DRrVrD3f6k0RDDGzVB2BaGWQdWkxYIf1zHuhrinaKOwFG9yR0viBxlvraw9WT2UR",
  render_errors: [view: LocaWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: LocaWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :loca_web, :generators,
  context_app: :loca

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

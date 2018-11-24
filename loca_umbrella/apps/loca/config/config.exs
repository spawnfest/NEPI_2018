use Mix.Config

config :loca, ecto_repos: [Loca.Repo]

import_config "#{Mix.env}.exs"

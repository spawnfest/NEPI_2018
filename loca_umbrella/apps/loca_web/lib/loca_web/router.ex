defmodule LocaWeb.Router do
  use LocaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LocaWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/join/:game_id", PageController, :pre_join
    get "/join/:game_id/:name", PageController, :join
    post "/check_position/:game_id/:name", PageController, :check_position
    post "/start_game", PageController, :start_game
  end

  # Other scopes may use custom stacks.
  # scope "/api", LocaWeb do
  #   pipe_through :api
  # end
end

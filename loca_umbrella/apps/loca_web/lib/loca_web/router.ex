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

    get "/", GameController, :index
    get "/join/:game_id", GameController, :make_user
    get "/join/:game_id/:name", GameController, :join
    post "/check_position/:game_id/:name", GameController, :check_position
    post "/start_game", GameController, :start_game
  end

  # Other scopes may use custom stacks.
  # scope "/api", LocaWeb do
  #   pipe_through :api
  # end
end

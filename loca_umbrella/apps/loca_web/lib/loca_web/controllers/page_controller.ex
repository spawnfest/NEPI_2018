defmodule LocaWeb.PageController do
  use LocaWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def game(conn, _params) do
    render conn, "game.html", game_id: 0
  end

  def start_game(conn, params) do
    {:ok, markers, _} = Plug.Conn.read_body(conn)
    game_id =
    Poison.Parser.parse!(markers)
    |> Loca.GameManager.start_game
    json conn, %{ game_id: game_id }
  end

  def check_position(conn, params) do
    {:ok, position, _} = Plug.Conn.read_body(conn)
  end

  def join(conn, %{ "game_id" => game_id }) do
    render conn, "game.html", game_id: game_id
  end

end

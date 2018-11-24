defmodule LocaWeb.PageController do
  use LocaWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def start_game(conn, params) do
    {:ok, markers, _} = Plug.Conn.read_body(conn)
    game_id =
    Poison.Parser.parse!(markers)
    |> Loca.GameManager.start_game
    json conn, %{ game_id: game_id }
  end

  def check_position(conn, %{ "game_id" => game_id }) do
    {:ok, position, _} = Plug.Conn.read_body(conn)
    parsed_position = Poison.Parser.parse!(position)
    result = Loca.GameManager.check_position(game_id, parsed_position)
    json conn, %{ status: result }
  end

  def join(conn, %{ "game_id" => game_id }) do
    render conn, "game.html", game_id: game_id
  end

end

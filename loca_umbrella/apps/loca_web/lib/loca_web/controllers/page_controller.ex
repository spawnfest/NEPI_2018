defmodule LocaWeb.PageController do
  use LocaWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def start_game(conn, params) do
    {:ok, markers, _} = Plug.Conn.read_body(conn)
    game_id = Loca.GameManager.start_game(markers)
    send_resp(conn, 200, "body: #{game_id}")
  end
end

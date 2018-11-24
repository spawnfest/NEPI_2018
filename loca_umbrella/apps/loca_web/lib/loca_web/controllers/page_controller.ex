defmodule LocaWeb.PageController do
  use LocaWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def start_game(conn, params) do
    {:ok, markers, _} = Plug.Conn.read_body(conn)
    IO.inspect Poison.Parser.parse!(markers)
    json conn, %{id: 123}

  end
end

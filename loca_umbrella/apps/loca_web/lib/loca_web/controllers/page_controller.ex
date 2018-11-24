defmodule LocaWeb.PageController do
  use LocaWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

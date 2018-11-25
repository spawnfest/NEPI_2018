defmodule LocaWeb.GameChannel do
  use LocaWeb, :channel

  def join("game:" <> _game_id, payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("moved", payload, socket) do
    IO.inspect payload
    broadcast socket, "player_moved", payload
    {:noreply, socket}
  end

  def handle_in("state", payload, socket) do
    IO.inspect payload
    broadcast socket, "player_state_changed", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end

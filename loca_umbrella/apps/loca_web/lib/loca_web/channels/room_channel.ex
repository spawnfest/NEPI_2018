defmodule HelloWeb.RoomChannel do
  use Phoenix.Channel

  def join("game:test", _message, socket) do
    {:ok, socket}
  end

  def join("game:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new_location", %{"lng" => lng, "lat" => lat}, socket) do
    broadcast!(socket, "new_location", %{lng: lng, lat: lat})
    {:noreply, socket}
  end
end
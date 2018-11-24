defmodule Loca.GameManager do
  use GenServer

  def start_link(opts \\ []), do: GenServer.start_link(__MODULE__, :ok, opts)

  def start_game(list) do
    game_id = UUID.uuid4(:hex)
    GenServer.start_link(__MODULE__, list, name: {:global, game_id})
    game_id
  end

  def join_game(game_id, name, position = %{"lng" => _lng, "lat" => _lat}),
    do: GenServer.call({:global, game_id}, {:join_game, name, position})

  def check_position(game_id, position = %{"lng" => _lng, "lat" => _lat}),
    do: GenServer.call({:global, game_id}, {:check_position, position})

  def init(list), do: {:ok, %{markers: list, player: %{}}}

  def get_state(game_id), do: GenServer.call({:global, game_id}, :check_state)

  def get_player_location(game_id), do: GenServer.call({:global, game_id}, :get_player_location)

  def handle_call(:check_state, _from, state), do: {:reply, state, state}

  def handle_call({:join_game, name, position = %{"lng" => _lng, "lat" => _lat}}, _from, state) do
    new_player =
      state.player
      |> Map.put(:name, name)
      |> Map.put(:position, position)

    {:reply, :ok, %{state | player: new_player}}
  end

  def handle_call(:get_player_location, _from, state), do: {:reply, state.player.position, state}

  def handle_call({:check_position, position = %{"lng" => _lng, "lat" => _lat}}, _from, state) do
    old_distance = calculate_distance(state.markers, state.player.position)
    new_distance = calculate_distance(state.markers, position)

    result =
      cond do
        trunc(new_distance) == 0 -> :on_point
        old_distance - new_distance > 0 -> :closer
        old_distance - new_distance < 0 -> :further
        old_distance - new_distance == 0 -> :no_movement
      end

    new_state = update_state(state, position, result)

    cond do
      length(new_state.markers) == 0 -> {:reply, %{"result" => :winner, "distance" => new_distance}, new_state}
      true -> {:reply, %{"result" => result, "distance" => new_distance}, new_state}
    end
  end

  defp update_state(state, position, :on_point),
    do: %{state | markers: tl(state.markers), player: %{state.player | position: position}}

  defp update_state(state, _position, :no_movement), do: state

  defp update_state(state, position, _result),
    do: %{state | player: %{state.player | position: position}}

  defp calculate_distance([%{"lng" => marker_lng, "lat" => marker_lat} | _rest], %{
         "lng" => player_lng,
         "lat" => player_lat
       }),
       do: distance_in_meters(marker_lat, marker_lng, player_lat, player_lng)

  defp square(x), do: x * x


  defp distance_in_meters(lat1, lon1, lat2, lon2) do
      earthRadiusMeters = 6_371_000

      dLat = degreesToRadians(lat2-lat1)
      dLon = degreesToRadians(lon2-lon1)

      a = square(:math.sin(dLat/2)) + (square(:math.sin(dLon/2)) * :math.cos(degreesToRadians(lat1)) * :math.cos(degreesToRadians(lat2)))

      c = 2 * :math.atan2(:math.sqrt(a), :math.sqrt(1-a))
      earthRadiusMeters * c
  end

  defp degreesToRadians(degrees), do: degrees * :math.pi / 180
end

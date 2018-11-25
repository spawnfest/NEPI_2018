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

  def check_position(game_id, name, position = %{"lng" => _lng, "lat" => _lat}),
    do: GenServer.call({:global, game_id}, {:check_position, name, position})

  def init(list), do: {:ok, %{markers: list, players: []}}

  def get_state(game_id), do: GenServer.call({:global, game_id}, :check_state)

  def get_player_location(game_id, name),
    do: GenServer.call({:global, game_id}, {:get_player_location, name})

  def handle_call(:check_state, _from, state), do: {:reply, state, state}

  def handle_call({:join_game, name, position = %{"lng" => _lng, "lat" => _lat}}, _from, state) do
    new_player = %{"name" => name, "position" => position}

    {:reply, :ok, %{state | players: state.players ++ [new_player]}}
  end

  def handle_call({:get_player_location, name}, _from, state),
    do: {:reply, find_player(state.players, name)["position"], state}

  def handle_call(
        {:check_position, name, position = %{"lng" => _lng, "lat" => _lat}},
        _from,
        state
      ) do
    old_distance = calculate_distance(state.markers, find_player(state.players, name)["position"])
    new_distance = calculate_distance(state.markers, position)

    result =
      cond do
        trunc(new_distance / 10) == 0 -> :on_point
        old_distance - new_distance > 0 -> :closer
        old_distance - new_distance < 0 -> :further
        old_distance - new_distance == 0 -> :no_movement
      end

    new_state =
      cond do
        length(state.markers) > 0 -> update_state(state, position, name, result)
        true -> state
      end

    cond do
      length(new_state.markers) == 0 ->
        {:reply,
         %{"result" => %{"action" => :winner, "player" => name}, "distance" => new_distance},
         new_state}

      true ->
        {:reply,
         %{"result" => %{"action" => result, "player" => name}, "distance" => new_distance},
         new_state}
    end
  end

  defp update_state(state, position, name, :on_point),
    do: %{
      state
      | markers: tl(state.markers),
        players: update_players_list(state.players, name, position)
    }

  defp update_state(state, _position, _name, :no_movement), do: state

  defp update_state(state, position, name, _result),
    do: %{state | players: update_players_list(state.players, name, position)}

  defp update_players_list(players, name, position) do
    player_to_change = find_player(players, name)
    (players -- [player_to_change]) ++ [%{player_to_change | "position" => position}]
  end

  defp calculate_distance([], _position), do: -11

  defp calculate_distance([%{"lng" => marker_lng, "lat" => marker_lat} | _rest], %{
         "lat" => player_lat,
         "lng" => player_lng
       }),
       do: distance_in_meters(marker_lat, marker_lng, player_lat, player_lng)

  defp calculate_distance(_, _), do: -11

  defp square(x), do: x * x

  defp distance_in_meters(lat1, lon1, lat2, lon2) do
    earthRadiusMeters = 6_371_000

    dLat = degreesToRadians(lat2 - lat1)
    dLon = degreesToRadians(lon2 - lon1)

    a =
      square(:math.sin(dLat / 2)) +
        square(:math.sin(dLon / 2)) * :math.cos(degreesToRadians(lat1)) *
          :math.cos(degreesToRadians(lat2))

    c = 2 * :math.atan2(:math.sqrt(a), :math.sqrt(1 - a))
    earthRadiusMeters * c
  end

  defp degreesToRadians(degrees), do: degrees * :math.pi() / 180

  def find_player(players, name),
    do: Enum.find(players, fn player -> match?(%{"name" => name, "position" => _}, player) end)
end

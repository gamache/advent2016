defmodule Advent11 do
  @floor_map %{"first" => 1, "second" => 2, "third" => 3, "fourth" => 4}
  @item_regex ~r"""
    (?<element> [^-\s]+) [-\s]
    (?:
      (?<generator> generator)
      |
      (?: compatible \s (?<microchip> microchip) )
    )
  """x
  defp add_item(item, state, floor) do
    case Regex.named_captures(@item_regex, item) do
      %{"element" => e, "generator" => g, "microchip" => m}=match ->
        elt = String.to_atom(e)
        type = if g =="generator", do: :generator, else: :microchip
        nfloor = @floor_map[floor]
        new_floors = Map.put(state.floors, nfloor, [{elt, type} | Map.get(state.floors, nfloor)])
        %{state | floors: new_floors}
      nil ->
        raise ArgumentError, "no regex match for #{inspect(item)}"
    end
  end

  @line_regex ~r"""
    The \s (?<floor> \S+) \s floor \s contains \s
    (?: (?: nothing \s relevant) | a \s (?<stuff> .+?) \.)
  """x
  def apply_input(line, state) do
    case Regex.named_captures(@line_regex, line) do
      %{"floor" => floor, "stuff" => stuff} ->
        stuff
        |> String.split(~r/,?(?: and)? a /, trim: true)
        |> IO.inspect
        |> Enum.reduce(state, fn (item, st) -> add_item(item, st, floor) end)
      _ ->
        raise ArgumentError, line
    end
  end


  def valid_floor_items?(items) do
    generator_elements =
      items
      |> Enum.filter(fn ({_elt, type}) -> type == :generator end)
      |> Enum.map(fn ({elt, _type}) -> elt end)

    microchip_elements =
      items
      |> Enum.filter(fn ({_elt, type}) -> type == :microchip end)
      |> Enum.map(fn ({elt, _type}) -> elt end)

    unpaired_microchip_elements = microchip_elements -- generator_elements

    Enum.count(unpaired_microchip_elements) == 0 ||
    Enum.count(generator_elements) == 0
  end

  def valid_elevator_items?(items) do
    case items do
      [{elt1, :generator}, {elt2, :microchip}] -> elt1 == elt2
      [{elt1, :microchip}, {elt2, :generator}] -> elt1 == elt2
      _ -> true
    end
  end

  def item_combinations(items) do
    do_combinations(items, 2) |> Enum.drop(1) |> Enum.flat_map(&(&1))
  end

  ## I cribbed this from github.com/tallakt/comb
  def do_combinations(enum, k) do
    combinations_by_length = [[[]]|List.duplicate([], k)]

    list = Enum.to_list(enum)
    List.foldr list, combinations_by_length, fn x, next ->
      sub = :lists.droplast(next)
      step = [[]|(for l <- sub, do: (for s <- l, do: [x|s]))]
      :lists.zipwith(&:lists.append/2, step, next)
    end
  end


  def next_states(state) do
    floor_items = state.floors[state.floor]
    Enum.flat_map(item_combinations(floor_items), fn (item_group) ->
      [
        move_items(state, item_group, state.floor - 1),
        move_items(state, item_group, state.floor + 1),
      ]
    end)
    |> Enum.filter(&(&1))

  end

  defp move_items(_state, _items, 0), do: nil
  defp move_items(_state, _items, 5), do: nil

  defp move_items(state, items, new_floor) do
    new_floor_items = state.floors[new_floor] ++ items
    old_floor_items = state.floors[state.floor] -- items
    floors = state.floors
             |> Map.put(state.floor, old_floor_items)
             |> Map.put(new_floor, new_floor_items)
    if valid_floor_items?(new_floor_items) &&
       valid_floor_items?(old_floor_items) &&
       valid_elevator_items?(items) do
      %{state | floor: new_floor, floors: floors}
    end
  end

  @initial_state %{
    floors: %{1 => [], 2 => [], 3 => [], 4 => []},
    floor: 1
  }

  def solve(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(@initial_state, &apply_input/2)
    |> IO.inspect
    |> bfs
  end

  def done?(state) do
    state.floors[1] == [] &&
    state.floors[2] == [] &&
    state.floors[3] == [] &&
    state.floor == 4
  end

  def bfs(initial_state), do: bfs([initial_state], 0, %{})

  def bfs([], step_number, _), do: "dead end at #{step_number}"

  def bfs(states, step_number, state_hashes) do
    IO.inspect {Enum.count(states), step_number, Enum.count(state_hashes)}
    Enum.each(states, fn (s) -> if done?(s), do: exit(step_number) end)

    next_states =
      states
      |> Enum.flat_map(&next_states/1)
      |> Enum.map(fn (s) -> Map.put(s, :hash, state_hash(s)) end)
      |> Enum.reject(fn (s) -> Map.get(state_hashes, s.hash) end)

    next_state_hashes = Enum.reduce next_states, state_hashes, fn (s, hashes) ->
      Map.put(hashes, s.hash, true)
    end

    bfs(next_states, step_number+1, next_state_hashes)
  end

  defp state_hash(state) do
    #:crypto.hash(:md5, inspect(state)) |> Base.encode64
    ( (state.floors[1] |> Enum.sort |> Enum.map(&(inspect(&1))) |> Enum.join(",")) <> "|" <>
      (state.floors[2] |> Enum.sort |> Enum.map(&(inspect(&1))) |> Enum.join(",")) <> "|" <>
      (state.floors[3] |> Enum.sort |> Enum.map(&(inspect(&1))) |> Enum.join(",")) <> "|" <>
      (state.floors[4] |> Enum.sort |> Enum.map(&(inspect(&1))) |> Enum.join(",")) <> "|" <>
    #( (state.floors[1] |> Enum.map(&(inspect(&1))) |> Enum.join(",")) <> "|" <>
      #(state.floors[2] |> Enum.map(&(inspect(&1))) |> Enum.join(",")) <> "|" <>
      #(state.floors[3] |> Enum.map(&(inspect(&1))) |> Enum.join(",")) <> "|" <>
      #(state.floors[4] |> Enum.map(&(inspect(&1))) |> Enum.join(",")) <> "|" <>
      to_string(state.floor) )
    |> :crypto.md5
    |> Base.encode64
  end

end

{:ok, input} = File.read("input")
input |> Advent11.solve |> IO.inspect


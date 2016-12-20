defmodule Advent15 do
  @initial_state %{
    time: 0,
    discs: %{}  # e.g., %{1 => {5, 4}, 2 => {2, 1}}
  }

  def solve(input) do
    input
    |> String.split("\n", trim: true)
    |> add_discs(@initial_state)
    |> apply_extra_disc_for_part_two
    |> find_slot
  end

  def apply_extra_disc_for_part_two(state) do
    new_disc_num = 1 + (state.discs |> Map.keys |> Enum.max)
    %{state | discs: Map.put(state.discs, new_disc_num, {11, 0})}
  end

  def add_discs(disc_lines, state) do
    Enum.reduce disc_lines, state, fn (disc_line, st) ->
      {disc_num, num_positions, starting_position} = parse_disc_line(disc_line)
      %{st | discs: Map.put(st.discs, disc_num, {num_positions, starting_position})}
    end
  end

  @disc_line_regex ~r"""
    Disc \s \#
    (?<disc_num> \d+) \s has \s
    (?<num_positions> \d+) \s positions; \s at \s time=0, \s
    it \s is \s at \s position \s
    (?<starting_position> \d+) \.
  """x

  def parse_disc_line(line) do
    case Regex.named_captures(@disc_line_regex, line) do
      nil ->
        raise ArgumentError, "regex should match but didn't"
      %{"disc_num" => dn, "num_positions" => np, "starting_position" => sp} ->
        {String.to_integer(dn), String.to_integer(np), String.to_integer(sp)}
    end
  end

  def find_slot(state) do
    if slot?(state), do: state, else: state |> advance |> find_slot
  end

  #def slot?(state) do
    #state.discs
    #|> Map.values
    #|> Enum.all?(fn ({_, pos}) -> pos == 0 end)
  #end

  def slot?(state) do
    disc_nums = state.discs |> Map.keys |> Enum.sort
    Enum.reduce disc_nums, true, fn (num, acc) ->
      acc && case Map.get(state.discs, num) do
        {npos, pos} -> rem(pos + num, npos) == 0
      end
    end
  end

  def advance(state) do
    discs = Enum.reduce state.discs, %{}, fn ({ndisc, {npos, pos}}, acc) ->
      Map.put(acc, ndisc, {npos, rem(pos+1, npos)})
    end
    %{state | time: state.time + 1, discs: discs}
  end
end

input = File.read!("input")
input |> Advent15.solve |> IO.inspect


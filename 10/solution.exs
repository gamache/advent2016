defmodule Advent10 do
  @initial_state %{
    outputs: %{},
    bots: %{},
  }


  def assign_values(state, bot_n, low, high, low_target, high_target) do
    with {:ok, state1} = assign_value(state, bot_n, low, low_target),
         {:ok, state2} = assign_value(state1, bot_n, high, high_target),
     do: {:ok, state2}
  end

  def assign_value(state, _bot_n, value, "output "<>out) do
    IO.puts "output #{out} got value #{value}"
    {:ok, state}
  end

  def assign_value(state, _bot_n, value, "bot "<>bot) do
    case state.bots[bot] do
      [_, _] ->
        :nope
      nil ->
        {:ok, %{state | bots: Map.put(state.bots, bot, [value])}}
      [v1] ->
        {:ok, %{state | bots: Map.put(state.bots, bot, [v1, value])}}
    end
  end


  defp order_values(a, b) do
    if String.to_integer(a) <= String.to_integer(b), do: {a, b}, else: {b, a}
  end


  def apply_cmds(state, [], []), do: state

  def apply_cmds(state, [], cmds_to_retry) do
    #IO.inspect {:retrying, state.bots["8"]}
    apply_cmds(state, cmds_to_retry, [])
  end

  @value_regex ~r"""
    (?<value_n> \d+) \s
    goes \s to \s bot \s (?<value_target> \d+)
  """x
  def apply_cmds(state, ["value "<>cmd | cmds], cmds_to_retry) do
    full_cmd = "value "<>cmd
    case Regex.named_captures(@value_regex, cmd) do
      %{"value_n" => value_n, "value_target" => bot_n} ->
        case assign_value(state, bot_n, value_n, "bot "<>bot_n) do
          {:ok, new_state} ->
            apply_cmds(new_state, cmds, cmds_to_retry)
          _ ->
            apply_cmds(state, cmds, cmds_to_retry ++ [full_cmd])
        end
      _ ->
        raise ArgumentError, "regex should match but didn't"
    end
  end

  @bot_regex ~r"""
    (?<bot_n> \d+) \s
    gives \s low \s to \s (?<low_target> (?: bot | output) \s \d+) \s
    and \s high \s to \s (?<high_target> (?: bot | output) \s \d+)
  """x
  def apply_cmds(state, ["bot "<>cmd | cmds], cmds_to_retry) do
    full_cmd = "bot "<>cmd
    case Regex.named_captures(@bot_regex, cmd) do
      %{"bot_n" => bot_n, "low_target" => lt, "high_target" => ht} ->
        case state.bots[bot_n] do
          [v1, v2] ->
            {low, high} = order_values(v1, v2)

            #if low=="17" && high=="61" do
              #IO.puts bot_n
              #exit :win
            #end

            case assign_values(state, bot_n, low, high, lt, ht) do
              {:ok, new_state} ->
                new_bots = Map.put(new_state.bots, bot_n, nil)
                apply_cmds(%{new_state | bots: new_bots}, cmds, cmds_to_retry)
              _ ->
                apply_cmds(state, cmds, cmds_to_retry ++ [full_cmd])
            end
          _ ->
            apply_cmds(state, cmds, cmds_to_retry ++ [full_cmd])
        end
      _ ->
        raise ArgumentError, "regex should match but didn't"
    end
  end


  def solve(input) do
    cmds = input |> String.split("\n", trim: true) |> Enum.map(&String.trim_trailing/1)
    apply_cmds(@initial_state, cmds, []) |> IO.inspect
  end

end

{:ok, input} = File.read("input")
input |> Advent10.solve


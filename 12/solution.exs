defmodule Advent12 do
  @empty_state %{
    reg: %{"a" => 0, "b" => 0, "c" => 1, "d" => 0},
    cmds: [],
    pc: 0
  }

  def execute(state) do
    case Enum.at(state.cmds, state.pc) do
      nil -> state
      cmd -> execute(apply_cmd(state, cmd))
    end
  end

  def apply_cmd(state, "cpy "<>rest) do
    [src, dest] = String.split(rest, " ", limit: 2)
    val = if Regex.match?(~r/[abcd]/, src), do: Map.get(state.reg, src), else: String.to_integer(src)
    %{state |
      reg: Map.put(state.reg, dest, val),
      pc: state.pc + 1}
  end

  def apply_cmd(state, "inc "<>reg) do
    %{state |
      reg: Map.put(state.reg, reg, Map.get(state.reg, reg) + 1),
      pc: state.pc + 1}
  end

  def apply_cmd(state, "dec "<>reg) do
    %{state |
      reg: Map.put(state.reg, reg, Map.get(state.reg, reg) - 1),
      pc: state.pc + 1}
  end

  def apply_cmd(state, "jnz "<>rest) do
    [reg, offset] = String.split(rest, " ", limit: 2)
    if Map.get(state.reg, reg) == 0 do
      %{state | pc: state.pc + 1}
    else
      %{state | pc: state.pc + String.to_integer(offset)}
    end
  end

  def solve(input) do
    cmds = input |> String.split("\n", trim: true) |> Enum.map(&String.trim_trailing/1)
    state = %{@empty_state | cmds: cmds}
    end_state = execute(state)
    end_state.reg["a"]
  end
end

input = File.read!("input")
input |> Advent12.solve |> IO.inspect


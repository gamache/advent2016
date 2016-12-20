defmodule Advent08 do
  @row 0..49 |> Enum.reduce(%{}, fn (x,acc) -> Map.put(acc, x, false) end)
  @initial_state 0..5 |> Enum.reduce(%{}, fn (y,acc) -> Map.put(acc, y, @row) end)
  def new_state(), do: @initial_state

  def cols(state), do: state |> Map.get(0, %{}) |> Enum.count
  def rows(state), do: state |> Enum.count

  def set(state, a, b, value \\ true) do
    Enum.reduce state, state, fn ({bb, row}, st) ->
      if b != bb do
        st
      else
        Map.put(st, b, Map.put(row, a, value))
      end
    end
  end

  def get(state, a, b) do
    state |> Map.get(b, %{}) |> Map.get(a)
  end

  def display(state) do
    rows = rows(state)
    cols = cols(state)
    Enum.each 0..(rows-1), fn (b) ->
      Enum.each 0..(cols-1), fn (a) ->
        val = state |> Map.get(b, %{}) |> Map.get(a)
        (if val, do: "#", else: ".") |> IO.write
      end
      IO.write("\n")
    end
    state
  end

  @regex ~r"""
    (?<cmd> rect | rotate \s row | rotate \s column) \s+
    (?:
      (?: (?<a1>\d+) x (?<b1>\d+) )
      |
      (?: y= (?<a2>\d+) \s by \s (?<b2>\d+) )
      |
      (?: x= (?<a3>\d+) \s by \s (?<b3>\d+) )
    )
  """x

  def apply_cmd(cmd, state) do
    case Regex.named_captures(@regex, cmd) do
      %{"cmd" => "rect", "a1" => a, "b1" => b} ->
        rect(state, String.to_integer(a), String.to_integer(b))
      %{"cmd" => "rotate row", "a2" => a, "b2" => b} ->
        rotate_row(state, String.to_integer(a), String.to_integer(b))
      %{"cmd" => "rotate column", "a3" => a, "b3" => b} ->
        rotate_column(state, String.to_integer(a), String.to_integer(b))
      _ -> state
    end
  end

  def rect(state, a, b) do
    Enum.reduce 0..(b-1), state, fn (bb, st) ->
      Enum.reduce 0..(a-1), st, fn (aa, st2) ->
        set(st2, aa, bb)
      end
    end
  end

  def rotate_row(state, row, col_shift) do
    rows = rows(state)
    cols = cols(state)
    Enum.reduce 0..(cols-1), state, fn (c, st) ->
      Enum.reduce 0..(rows-1), st, fn (r, st2) ->
        if r == row do
          set(st2, rem((c+col_shift), cols), r, get(state, c, r))
        else
          st2
        end
      end
    end
  end

  def rotate_column(state, col, row_shift) do
    rows = rows(state)
    cols = cols(state)
    Enum.reduce 0..(cols-1), state, fn (c, st) ->
      Enum.reduce 0..(rows-1), st, fn (r, st2) ->
        if c == col do
          set(st2, c, rem((r+row_shift), rows), get(state, c, r))
        else
          st2
        end
      end
    end
  end

  def count_lit(state) do
    Map.values(state)
    |> Enum.map(fn (col) ->
      col |> Map.values |> Enum.filter(&(&1)) |> Enum.count
    end)
    |> Enum.sum
  end

  def solve(input) do
    input
    |> String.split(~r/\n/, trim: true)
    |> Enum.reduce(@initial_state, &apply_cmd/2)
    |> display
    |> count_lit
  end
end

{:ok, input} = File.read("input")
input |> Advent08.solve |> IO.puts


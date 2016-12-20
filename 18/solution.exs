defmodule Advent18 do
  @initial_state %{
    rows: %{},
    columns: 0,
  }

  def solve(input, nrows \\ 40) do
    input_row = parse_row(input)
    initial_state = %{@initial_state |
      rows: %{0 => input_row},
      columns: Enum.count(input_row)
    }
    Enum.reduce 1..(nrows-1), initial_state, fn (nrow, state) ->
      prev_row = Map.get(state.rows, nrow - 1)
      this_row = Enum.reduce 0..(state.columns-1), %{}, fn (ncol, acc) ->
        Map.put(acc, ncol, get_next_tile(prev_row, ncol))
      end
      %{state | rows: Map.put(state.rows, nrow, this_row)}
    end
  end

  def parse_row(input) do
    input
    |> String.split("", trim: true)
    |> Enum.reduce(%{}, fn (char, row) -> Map.put(row, Enum.count(row), char) end)
  end

  def get_next_tile(prev_row, ncol) do
    left = Map.get(prev_row, ncol-1, ".")
    center = Map.get(prev_row, ncol, ".")
    right = Map.get(prev_row, ncol+1, ".")

    is_trap = (trap?(left) && trap?(center) && safe?(right)) ||
              (trap?(center) && trap?(right) && safe?(left)) ||
              (trap?(left) && safe?(center) && safe?(right)) ||
              (trap?(right) && safe?(center) && safe?(left))
    if is_trap, do: "^", else: "."
  end

  defp trap?(x), do: x == "^"
  defp safe?(x), do: x == "."

  def display(state) do
    Enum.each 0..(Enum.count(state.rows)-1), fn (nrow) ->
      Enum.each 0..(state.columns-1), fn (ncol) ->
        IO.write(state.rows |> Map.get(nrow) |> Map.get(ncol))
      end
      IO.puts ""
    end
    state
  end

  def count_safe_tiles(state) do
    Enum.reduce 0..(Enum.count(state.rows)-1), 0, fn (nrow, acc) ->
      acc + Enum.reduce 0..(state.columns-1), 0, fn (ncol, row_acc) ->
        char = state.rows |> Map.get(nrow) |> Map.get(ncol)
        row_acc + if safe?(char), do: 1, else: 0
      end
    end
  end
end

input = File.read!("input")
input |> Advent18.solve(400000) |> Advent18.count_safe_tiles |> IO.puts


defmodule Advent02 do
  def next("1", "U"), do: "1"
  def next("1", "D"), do: "4"
  def next("1", "L"), do: "1"
  def next("1", "R"), do: "2"

  def next("2", "U"), do: "2"
  def next("2", "D"), do: "5"
  def next("2", "L"), do: "1"
  def next("2", "R"), do: "3"

  def next("3", "U"), do: "3"
  def next("3", "D"), do: "6"
  def next("3", "L"), do: "2"
  def next("3", "R"), do: "3"

  def next("4", "U"), do: "1"
  def next("4", "D"), do: "7"
  def next("4", "L"), do: "4"
  def next("4", "R"), do: "5"

  def next("5", "U"), do: "2"
  def next("5", "D"), do: "8"
  def next("5", "L"), do: "4"
  def next("5", "R"), do: "6"

  def next("6", "U"), do: "3"
  def next("6", "D"), do: "9"
  def next("6", "L"), do: "5"
  def next("6", "R"), do: "6"

  def next("7", "U"), do: "4"
  def next("7", "D"), do: "7"
  def next("7", "L"), do: "7"
  def next("7", "R"), do: "8"

  def next("8", "U"), do: "5"
  def next("8", "D"), do: "8"
  def next("8", "L"), do: "7"
  def next("8", "R"), do: "9"

  def next("9", "U"), do: "6"
  def next("9", "D"), do: "9"
  def next("9", "L"), do: "8"
  def next("9", "R"), do: "9"

  def next(x, ""), do: x


  def solve(input) do
    input_lines = String.split(input, ~r/\s+/)
    solve(input_lines, [])
  end

  def solve([], solution), do: Enum.join(solution, "")

  def solve(["" | rest], solution), do: solve(rest, solution)

  def solve([line | rest], solution) do
    start_num = ["5" | solution] |> List.last
    moves = line |> String.split("")
    num = Enum.reduce moves, start_num, fn (move, cur_num) ->
      next(cur_num, move)
    end
    solve(rest, solution ++ [num])
  end
end


defmodule Advent02_02 do
  def next("1", "U"), do: "1"
  def next("1", "D"), do: "3"
  def next("1", "L"), do: "1"
  def next("1", "R"), do: "1"

  def next("2", "U"), do: "2"
  def next("2", "D"), do: "6"
  def next("2", "L"), do: "2"
  def next("2", "R"), do: "3"

  def next("3", "U"), do: "1"
  def next("3", "D"), do: "7"
  def next("3", "L"), do: "2"
  def next("3", "R"), do: "4"

  def next("4", "U"), do: "4"
  def next("4", "D"), do: "8"
  def next("4", "L"), do: "3"
  def next("4", "R"), do: "4"

  def next("5", "U"), do: "5"
  def next("5", "D"), do: "5"
  def next("5", "L"), do: "5"
  def next("5", "R"), do: "6"

  def next("6", "U"), do: "2"
  def next("6", "D"), do: "A"
  def next("6", "L"), do: "5"
  def next("6", "R"), do: "7"

  def next("7", "U"), do: "3"
  def next("7", "D"), do: "B"
  def next("7", "L"), do: "6"
  def next("7", "R"), do: "8"

  def next("8", "U"), do: "8"
  def next("8", "D"), do: "C"
  def next("8", "L"), do: "7"
  def next("8", "R"), do: "9"

  def next("9", "U"), do: "9"
  def next("9", "D"), do: "9"
  def next("9", "L"), do: "8"
  def next("9", "R"), do: "9"

  def next("A", "U"), do: "6"
  def next("A", "D"), do: "A"
  def next("A", "L"), do: "A"
  def next("A", "R"), do: "B"

  def next("B", "U"), do: "7"
  def next("B", "D"), do: "D"
  def next("B", "L"), do: "A"
  def next("B", "R"), do: "C"

  def next("C", "U"), do: "8"
  def next("C", "D"), do: "C"
  def next("C", "L"), do: "B"
  def next("C", "R"), do: "C"

  def next("D", "U"), do: "B"
  def next("D", "D"), do: "D"
  def next("D", "L"), do: "D"
  def next("D", "R"), do: "D"

  def next(x, ""), do: x


  def solve(input) do
    input_lines = String.split(input, ~r/\s+/)
    solve(input_lines, [])
  end

  def solve([], solution), do: Enum.join(solution, "")

  def solve(["" | rest], solution), do: solve(rest, solution)

  def solve([line | rest], solution) do
    start_num = ["5" | solution] |> List.last
    moves = line |> String.split("")
    num = Enum.reduce moves, start_num, fn (move, cur_num) ->
      next(cur_num, move)
    end
    solve(rest, solution ++ [num])
  end
end

input = File.read!("input")

input |> Advent02.solve |> IO.puts
input |> Advent02_02.solve |> IO.puts

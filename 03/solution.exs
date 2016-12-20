defmodule Advent03 do
  def valid_triangle?([]), do: false

  def valid_triangle?([a, b, c]) do
    (a + b) > c && (a + c) > b && (b + c) > a
  end

  def solve(input) do
    input
    |> String.split(~r/\n/)
    |> Enum.map(fn (line) ->
      line
      |> String.split(~r/\s+/)
      |> Enum.filter(&(&1 != ""))
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.filter(&valid_triangle?/1)
    |> Enum.count
  end


  def solve2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.chunk(3)
    |> Enum.map(&count_chunk/1)
    |> Enum.sum
  end

  def count_chunk(chunk) do
    chunk_nums = chunk |> Enum.map(fn (line) ->
      line
      |> String.split(~r/\s+/, trim: true)
      |> Enum.map(&String.to_integer/1)
    end)

    x1 = chunk_nums |> Enum.at(0) |> Enum.at(0)
    y1 = chunk_nums |> Enum.at(1) |> Enum.at(0)
    z1 = chunk_nums |> Enum.at(2) |> Enum.at(0)

    x2 = chunk_nums |> Enum.at(0) |> Enum.at(1)
    y2 = chunk_nums |> Enum.at(1) |> Enum.at(1)
    z2 = chunk_nums |> Enum.at(2) |> Enum.at(1)

    x3 = chunk_nums |> Enum.at(0) |> Enum.at(2)
    y3 = chunk_nums |> Enum.at(1) |> Enum.at(2)
    z3 = chunk_nums |> Enum.at(2) |> Enum.at(2)

    (if valid_triangle?([x1, y1, z1]), do: 1, else: 0) +
    (if valid_triangle?([x2, y2, z2]), do: 1, else: 0) +
    (if valid_triangle?([x3, y3, z3]), do: 1, else: 0)
  end
end

input = File.read!("input")

input |> Advent03.solve |> IO.puts
input |> Advent03.solve2 |> IO.puts


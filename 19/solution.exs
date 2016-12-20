defmodule Advent19 do

  # 1 2 3 4 5 becomes 1 3 5 becomes 3 5 becomes 3
  # 1 2 3 4 becomes 1 3 becomes 1

  def swap([v1]), do: v1

  def swap([v1, v2]), do: v1

  def swap(list) do
    IO.inspect list
    if rem(Enum.count(list), 2) == 0 do
      list |> Enum.take_every(2) |> swap
    else # odd
      tl(list |> Enum.take_every(2)) |> swap
    end
  end

  def solve(input) do
    input..1
    |> Enum.reduce([], fn (i, acc) -> [i | acc] end)
    |> swap
  end
end

#3012210 |> Advent19.solve |> IO.puts
#5 |> Advent19.solve |> IO.puts


defmodule Advent19_02 do

  def swap([v1]), do: v1

  def swap([v1, v2]), do: v1

  def swap(list) do
    #IO.inspect(list)
    remove_index = round(Float.floor(Enum.count(list) / 2.0))
    {part1, part2} = Enum.split(list, remove_index)
    swap(tl(part1) ++ tl(part2) ++ [hd(part1)])
  end

  def solve(input) do
    input..1
    |> Enum.reduce([], fn (i, acc) -> [i | acc] end)
    |> swap
  end
end

3012210 |> Advent19_02.solve |> IO.puts
#5 |> Advent19_02.solve |> IO.puts

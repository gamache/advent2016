defmodule Advent01 do
  def new_direction(direction, turn) do
    case turn do
      "L" ->
        case direction do
          [1, 0] -> [0, 1]
          [0, 1] -> [-1, 0]
          [-1, 0] -> [0, -1]
          [0, -1] -> [1, 0]
        end
      "R" ->
        case direction do
          [1, 0] -> [0, -1]
          [0, -1] -> [-1, 0]
          [-1, 0] -> [0, 1]
          [0, 1] -> [1, 0]
        end
    end
  end

  def get_path_length(x, y, _, []) do
    abs(x) + abs(y)
  end

  def get_path_length(x, y, direction, [move | rest]) do
    turn = String.slice(move, 0..0)
    spaces = move |> String.slice(1..-1) |> String.to_integer
    new_dir = new_direction(direction, turn)
    dx = Enum.at(new_dir, 0) * spaces
    dy = Enum.at(new_dir, 1) * spaces
    get_path_length(x+dx, y+dy, new_dir, rest)
  end

  def solve(input) do
    inputs = String.split(input, ", ")
    get_path_length(0, 0, [0,1], inputs)
  end


  def get_path_length2(_x, _y, _dir, [], _vis) do
    :no_repeat_visits
  end

  def get_path_length2(x, y, direction, [move | rest], visited) do
    turn = String.slice(move, 0..0)
    spaces = move |> String.slice(1..-1) |> String.to_integer
    new_dir = new_direction(direction, turn)
    new_visited = Enum.reduce 1..spaces, visited, fn (spc, acc) ->
      xx = x + Enum.at(new_dir, 0) * spc
      yy = y + Enum.at(new_dir, 1) * spc
      if Enum.member?(visited, [xx, yy]) do
        IO.puts "\n\n"
        IO.inspect [xx, yy]
        IO.inspect abs(xx) + abs(yy)
        IO.inspect visited
        exit 0
      end
      [[xx, yy] | acc]
    end
    new_x = x + Enum.at(new_dir, 0) * spaces
    new_y = y + Enum.at(new_dir, 1) * spaces
    get_path_length2(new_x, new_y, new_dir, rest, new_visited)
  end

  def solve2(input) do
    inputs = input
             |> String.split("\n", trim: true)
             |> Enum.flat_map(&(String.split(&1, ", ", trim: true)))
    get_path_length2(0, 0, [0,1], inputs, [[0,0]])
  end
end

input = File.read!("input")

input
|> Advent01.solve
|> IO.puts # 243

input
|> Advent01.solve2
|> IO.puts #271 is too high


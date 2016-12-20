defmodule Advent13 do
  @n 1350

  def count_binary_ones(n) do
    n
    |> Integer.to_string(2)
    |> String.split("", trim: true)
    |> Enum.filter(&(&1 == "1"))
    |> Enum.count
  end

  def bfs(initial_state), do: bfs([initial_state], 0, %{})

  def bfs(states, nsteps, states_hash) do
    if nsteps == 51 do
      exit Enum.count(states_hash)
    end

    if Enum.member?(states, [31,39]) do
      nsteps
    else
      next_states_hash = Enum.reduce states, states_hash, fn (state, acc) ->
        Map.put(acc, state, true)
      end

      next_states =
        states
        |> Enum.flat_map(fn ([x,y]) -> next_states(x, y) end)
        |> Enum.uniq
        |> Enum.reject(fn (s) -> Map.get(next_states_hash, s) end)

      bfs(next_states, nsteps + 1, next_states_hash)
    end
  end

  def next_states(x, y) do
    [
      [x-1, y],
      [x, y-1],
      [x+1, y],
      [x, y+1]
    ]
    |> Enum.reject(fn ([x, y]) -> wall?(x, y) end)
  end

  def wall?(-1, _), do: true
  def wall?(_, -1), do: true

  def wall?(x, y) do
    sum = x*x + 3*x + 2*x*y + y + y*y + @n
    ones = count_binary_ones(sum)
    rem(ones, 2) == 1
  end
end

Advent13.bfs([1,1]) |> IO.inspect


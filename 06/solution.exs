defmodule Advent06 do
  def add_freqs(freqs, msg) do
    chars = String.split(msg, ~r//, trim: true)
    {freqs, _} = Enum.reduce chars, {freqs, 0}, fn (c, {f, i}) ->
      char_freqs = Map.get(f, i, %{})
      char_freq = Map.get(char_freqs, c, 0)
      {Map.put(f, i, Map.put(char_freqs, c, char_freq+1)), i+1}
    end
    freqs
  end

  def top_char_at(freqs, i) do
    freqs
    |> Map.get(i)
    |> Enum.sort(fn ({_,n1}, {_,n2}) -> n1 > n2 end)
    |> List.first
    |> elem(0)
  end

  def solve(input) do
    msgs = String.split(input, ~r/\n/, trim: true)
    freqs = Enum.reduce msgs, %{}, fn (msg, f) ->
      add_freqs(f, msg)
    end
    keys = freqs |> Map.keys |> Enum.sort
    Enum.reduce keys, "", fn (i, str) ->
      str <> top_char_at(freqs, i)
    end
  end


  def bottom_char_at(freqs, i) do
    freqs
    |> Map.get(i)
    |> Enum.sort(fn ({_,n1}, {_,n2}) -> n1 < n2 end)
    |> List.first
    |> elem(0)
  end

  def solve2(input) do
    msgs = String.split(input, ~r/\n/, trim: true)
    freqs = Enum.reduce msgs, %{}, fn (msg, f) ->
      add_freqs(f, msg)
    end
    keys = freqs |> Map.keys |> Enum.sort
    Enum.reduce keys, "", fn (i, str) ->
      str <> bottom_char_at(freqs, i)
    end
  end
end

{:ok, input} = File.read("input")
Advent06.solve(input) |> IO.puts
Advent06.solve2(input) |> IO.puts


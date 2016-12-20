defmodule Advent09 do
  def decompress(str) do
    decompress(str, "")
  end

  @regex ~r" (?<len> \d+) x (?<times> \d+) \) (?<str> .+) "x

  def decompress("", acc), do: acc

  def decompress("(" <> rest, acc) do
    case Regex.named_captures(@regex, rest) do
      nil ->
        raise ArgumentError, "regex should match but didn't"
      %{"len" => l, "times" => t, "str" => str} ->
        len = String.to_integer(l)
        times = String.to_integer(t)
        {repeat, remainder} = String.split_at(str, len)
        decompress(remainder, acc <> String.duplicate(repeat, times))
    end
  end

  def decompress(str, acc) do
    {c, rest} = String.split_at(str, 1)
    decompress(rest, acc <> c)
  end

  def solve(input) do
    input
    |> String.trim_trailing
    |> decompress
    |> String.length
  end
end

defmodule Advent09_02 do
  @parse_regex ~r"""
    (?<text> [^\(]* )
    (?:
      \( (?<marker_len> \d+) x (?<marker_times> \d+) \)
    )?
    (?<rest> .*)
  """x

  @marker_regex ~r/ \( (?<len> \d+) x (?<times> \d+) \) /x

  def find_length(input) do
    case Regex.named_captures(@parse_regex, input) do
      %{"text" => "", "marker_len" => "", "marker_times" => "", "rest" => ""} ->
        0

      %{"text" => text, "marker_len" => len, "marker_times" => times, "rest" => rest} ->
        String.length(text) + if len == "" do
          find_length(rest)
        else
          i_len = String.to_integer(len)
          i_times = String.to_integer(times)
          {str1, str2} = String.split_at(rest, i_len)
          i_times * find_length(str1) + find_length(str2)
        end
    end
  end

  def solve(input) do
    find_length(input)
  end
end

{:ok, input} = File.read("input")
input |> Advent09.solve |> IO.puts
input |> Advent09_02.solve |> IO.puts


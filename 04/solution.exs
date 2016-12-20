defmodule Advent04 do
  @line_regex ~r/^ (?<name>.+?) (?<sid>\d+) \[ (?<checksum>.....) \]/x
  def decompose(line) do
    nc = Regex.named_captures(@line_regex, line)
    {nc["name"], nc["sid"], nc["checksum"]}
  end

  # returns 0 if not real, returns sid if real
  def sid_value(line) do
    {name, sid, checksum} = decompose(line)
    if valid?(name, checksum), do: String.to_integer(sid), else: 0
  end

  def valid?(name, checksum) do
    name_chars = name |> String.split(~r//) |> Enum.filter(&(&1 != "-" && &1 != ""))
    char_freqs = Enum.reduce name_chars, %{}, fn (char, acc) ->
      Map.put(acc, char, Map.get(acc, char, 0) + 1)
    end
    checksum == get_checksum(char_freqs)
  end

  # returns top five chars as string, like "abdce"
  def get_checksum(freq_map) do
    Enum.sort(freq_map, fn ({c1,v1},{c2,v2}) ->
      cond do
        v1==v2 -> c1 < c2
        :else -> v1 > v2
      end
    end)
    |> Enum.map(fn {c, _v} -> c end)
    |> Enum.join
    |> String.slice(0..4)
  end

  def solve(input) do
    input
    |> String.split(~r/\n/)
    |> Enum.map(&sid_value/1)
    |> Enum.sum
  end


  def solve2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&to_valid_sid/1)
    |> Enum.filter(&(&1))
    |> Enum.each(&IO.inspect/1)
  end

  def to_valid_sid(line) do
    {name, sid, checksum} = decompose(line)
    if valid?(name, checksum) do
      i_sid = String.to_integer(sid)
      {name, decrypt(name, i_sid), i_sid}
    end
  end

  @alphabet "abcdefghijklmnopqrstuvwxyz" |> String.split("", trim: true)

  def rotate("-", i), do: " "

  def rotate(c, i) do
    c_index = @alphabet |> Enum.find_index(&(&1 == c))
    @alphabet |> Enum.at(rem(c_index + i, 26))
  end

  def decrypt(name, i), do: decrypt(name, i, "")

  def decrypt("", _, decrypted), do: decrypted

  def decrypt(name, i, decrypted) do
    [c, rest] = String.split(name, "", parts: 2)
    decrypt(rest, i, decrypted <> rotate(c, i))
  end
end

input = File.read!("input")

input |> Advent04.solve |> IO.inspect
input |> Advent04.solve2 |> IO.inspect

defmodule Advent14 do
  @initial_state %{
    index: 0,
    salt: nil,      # e.g., "abc"
    triplets: %{},  # e.g., %{18 => "8", 39 => "e", ...}
    fives: %{},     # e.g., %{200 => %{"9" => true}, 816 => %{"e" => true}, ...}
    keys: %{},      # e.g., %{39 => 816, 92 => 200, ...}
  }

  def solve(input) do
    %{@initial_state | salt: input} |> analyze_hashes
  end

  def display(state) do
    triplets = state.keys |> Map.keys |> Enum.sort
    Enum.reduce triplets, 1, fn (triplet, i) ->
      five = Map.get(state.keys, triplet)
      IO.puts "#{i}: #{triplet} #{five} (#{five-triplet}) \t #{hash(state.salt, triplet)} #{hash(state.salt, five)}"
      i + 1
    end
  end


  def analyze_hashes(state) do
    hash = hash(state.salt, state.index)

    ## add any triplet or five-char streak in this hash to the overall state
    triplets = case get_first_triplet(hash) do
      nil -> state.triplets
      c -> Map.put(state.triplets, state.index, c)
    end
    new_fives = get_fives(hash)
    fives = if new_fives == %{}, do: state.fives, else: Map.put(state.fives, state.index, new_fives)

    ## for each five-char streak we just found, check the previous 1000 indices
    ## for a matching triplet
    keys = Enum.reduce new_fives, state.keys, fn ({c,_}, keys_acc) ->
      Enum.reduce((state.index-1001)..(state.index-1), %{}, fn (i, new_keys) ->
        if c == Map.get(triplets, i) do
          Map.put(new_keys, i, state.index)
        else
          new_keys
        end
      end)
      |> Map.merge(keys_acc)
    end

    new_state = %{state |
      index: state.index + 1,
      triplets: triplets,
      fives: fives,
      keys: keys,
    }
    if Enum.count(keys) >= 100, do: new_state, else: analyze_hashes(new_state)
  end


  def hash(salt, i), do: repeat_hash(salt <> Integer.to_string(i), 2017)

  def repeat_hash(str, 0), do: str

  def repeat_hash(str, n), do: repeat_hash(hash(str), n - 1)


  def hash(salt), do: :crypto.hash(:md5, salt) |> Base.encode16 |> String.downcase


  @hex_letters "0123456789abcdef" |> String.split("", trim: true)

  def get_fives(hash) do
    Enum.reduce @hex_letters, %{}, fn (c, acc) ->
      five = String.duplicate(c, 5)
      if String.contains?(hash, five) do
        Map.put(acc, c, true)
      else
        acc
      end
    end
  end


  @triplet_regex ~r/^ .*? (?<char>.) \1 \1/x

  def get_first_triplet(hash_str) do
    case Regex.named_captures(@triplet_regex, hash_str) do
      %{"char" => c} -> c
      _ -> nil
    end
  end
end

Advent14.solve("qzyelonm") |> Advent14.display
#Advent14.solve("abc") |> Advent14.display


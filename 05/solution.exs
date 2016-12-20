defmodule Advent05 do
  def five_zeros?(str, i) do
    case :crypto.hash(:md5, "#{str}#{i}") |> Base.encode16 do
      "00000" <> rest ->
        String.slice(rest, 0..0)
      _ ->
        :nope
    end
  end

  def get_password(_, _, password, 8), do: password

  def get_password(code, i, password_so_far, chars_so_far) do
    case five_zeros?(code, i) do
      :nope ->
        get_password(code, i+1, password_so_far, chars_so_far)
      c ->
        get_password(code, i+1, password_so_far<>c, chars_so_far+1)
    end
  end

  def solve(code) do
    get_password(code, 0, "", 0) |> String.downcase
  end
end

defmodule Advent05_02 do
  def five_zeros?(str, i) do
    case :crypto.hash(:md5, "#{str}#{i}") |> Base.encode16 do
      "00000" <> rest ->
        pos = String.slice(rest, 0..0)
        char = String.slice(rest, 1..1)
        if pos >= "0" and pos <= "7", do: {String.to_integer(pos), char}
      _ ->
        nil
    end
  end

  def solve(code) do
    get_password(code, 0, %{}, 0) |> String.downcase
  end

  def get_password(_, _, password_map, 8) do
    Enum.reduce 0..7, "", fn (i, acc) ->
      acc <> Map.get(password_map, i)
    end
  end

  def get_password(code, i, password_map, chars_so_far) do
    case five_zeros?(code, i) do
      nil ->
        get_password(code, i+1, password_map, chars_so_far)
      {pos, char} ->
        new_password_map = %{pos => char} |> Map.merge(password_map)
        get_password(code, i+1, new_password_map, Enum.count(password_map))
    end
  end
end

#Advent05.solve("reyedfim") |> IO.puts
Advent05_02.solve("reyedfim") |> IO.puts


defmodule Advent16 do
  def solve({input, disk_size}) do
    input
    |> fill_disk(disk_size)
    |> checksum
  end

  def fill_disk(a, disk_size) do
    if String.length(a) >= disk_size do
      String.slice(a, 0..(disk_size-1))
    else
      b = a
          |> String.reverse
          |> String.replace("0", "Z")
          |> String.replace("1", "0")
          |> String.replace("Z", "1")
      fill_disk("#{a}0#{b}", disk_size)
    end
  end

  def checksum(data), do: checksum(data, [], 0)

  def checksum("00"<>data, sum, len), do: checksum(data, [1 | sum], len+1)
  def checksum("11"<>data, sum, len), do: checksum(data, [1 | sum], len+1)
  def checksum("01"<>data, sum, len), do: checksum(data, [0 | sum], len+1)
  def checksum("10"<>data, sum, len), do: checksum(data, [0 | sum], len+1)

  def checksum(_, sum, len) do
    sum_str = sum |> Enum.join("") |> String.reverse
    if rem(len, 2) == 1 do
      sum_str
    else
      checksum(sum_str)
    end
  end


end

#{"01111001100111011", 272} |> Advent16.solve |> IO.inspect
{"01111001100111011", 35651584} |> Advent16.solve |> IO.inspect


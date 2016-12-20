defmodule Advent07 do
  def supports_tls?(ip) do
    supports_tls?(ip, false, false)
  end

  def supports_tls?("["<>rest, _, supported),
    do: supports_tls?(rest, true, supported)

  def supports_tls?("]"<>rest, _, supported),
    do: supports_tls?(rest, false, supported)

  def supports_tls?(<<a, b, b, a, _rest::binary>>, true, _) when a != b,
    do: false

  def supports_tls?(<<a, b, b, a, rest::binary>>, false, _) when a != b,
    do: supports_tls?(rest, false, true)

  def supports_tls?(<<_c, rest::binary>>, in_brackets, supported),
    do: supports_tls?(rest, in_brackets, supported)

  def supports_tls?("", _, supported),
    do: supported

  def solve(input) do
    input
    |> String.split(~r/\n/, trim: true)
    |> Enum.filter(&supports_tls?/1)
    |> Enum.count
  end


  def supports_ssl?(ip) do
    {supernet_seqs, hypernet_seqs} = get_seqs(ip)
    Enum.any? supernet_seqs, fn (super_seq) ->
      Enum.any? get_abas(super_seq), fn ({a, b}) ->
        Enum.any? hypernet_seqs, &(String.contains?(&1, b<>a<>b))
      end
    end
  end

  def get_seqs(ip), do: get_seqs(ip, [], [], "")

  def get_seqs(ip, sseqs, hseqs, cur_seq)

  def get_seqs("[" <> rest, sseqs, hseqs, cur_seq) do
    get_seqs(rest, [cur_seq | sseqs], hseqs, "")
  end

  def get_seqs("]" <> rest, sseqs, hseqs, cur_seq) do
    get_seqs(rest, sseqs, [cur_seq | hseqs], "")
  end

  def get_seqs("", sseqs, hseqs, cur_seq) do
    {[cur_seq | sseqs], hseqs} #|> IO.inspect
  end

  def get_seqs(ip, sseqs, hseqs, cur_seq) do
    {first, rest} = String.split_at(ip, 1)
    get_seqs(rest, sseqs, hseqs, cur_seq<>first)
  end


  def get_abas(string), do: get_abas(string, [])

  def get_abas(<<a, b, a, rest::binary>>, abas) when a != b do
    aa = :erlang.iolist_to_binary([a])
    bb = :erlang.iolist_to_binary([b])
    get_abas(bb <> aa <> rest, [{aa, bb} | abas])
  end

  def get_abas(<<_, rest::binary>>, abas) do
    get_abas(rest, abas)
  end

  def get_abas("", abas), do: abas

  def solve2(input) do
    input
    |> String.split(~r/\n/, trim: true)
    |> Enum.filter(&supports_ssl?/1)
    |> Enum.count
  end
end

{:ok, input} = File.read("input")
#input |> Advent07.solve |> IO.puts
input |> Advent07.solve2 |> IO.puts


defmodule Advent17 do
  @initial_state %{
    x: 0,
    y: 0,
    path: "",
    passcode: nil,
    hash: nil,
  }

  def hash(state) do
    :crypto.hash(:md5, state.passcode <> state.path) |> Base.encode16 |> String.downcase
  end

  def hash!(state) do
    %{state | hash: hash(state)}
  end

  @bcdef "bcdef" |> String.split("", trim: true)
  def can_go_up?(state), do: (state.y > 0) && Enum.member?(@bcdef, (state.hash |> String.slice(0..0)))
  def can_go_down?(state), do: (state.y < 3) && Enum.member?(@bcdef, (state.hash |> String.slice(1..1)))
  def can_go_left?(state), do: (state.x > 0) && Enum.member?(@bcdef, (state.hash |> String.slice(2..2)))
  def can_go_right?(state), do: (state.x < 3) && Enum.member?(@bcdef, (state.hash |> String.slice(3..3)))

  def go_up(state), do: %{state | y: state.y - 1, path: state.path <> "U"} |> hash!
  def go_down(state), do: %{state | y: state.y + 1, path: state.path <> "D"} |> hash!
  def go_left(state), do: %{state | x: state.x - 1, path: state.path <> "L"} |> hash!
  def go_right(state), do: %{state | x: state.x + 1, path: state.path <> "R"} |> hash!

  def done?(state), do: (state.x == 3) && (state.y == 3)

  def bfs([], _), do: :dead_end

  def bfs(states, opts \\ []) do
    winners = states |> Enum.filter(&done?/1)
    if Enum.count(winners) > 0 do
      if opts[:keep_going] do
        Enum.each winners, fn (state) ->
          IO.puts "#{String.length(state.path)}\t#{state.path}"
        end
        bfs(states -- winners, opts)
      else
        winners |> Enum.at(0)
      end
    else
      Enum.reduce(states, [], fn (state, acc) ->
        acc ++ [
          (if can_go_up?(state), do: go_up(state)),
          (if can_go_down?(state), do: go_down(state)),
          (if can_go_left?(state), do: go_left(state)),
          (if can_go_right?(state), do: go_right(state))
        ]
      end)
      |> Enum.filter(&(&1))
      |> bfs(opts)
    end
  end


  def solve(input, opts \\ []) do
    state = %{@initial_state | passcode: input} |> hash!
    bfs([state], opts)
  end
end

#"ihgpwlah" |> Advent17.solve |> IO.inspect  # DDRRRD
"vkjiggvb" |> Advent17.solve |> IO.inspect
"vkjiggvb" |> Advent17.solve(keep_going: true) |> IO.inspect

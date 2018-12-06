defmodule Day1 do
  @behaviour Solution

  @moduledoc """
  iex> Day1.solve_part_1("+1
  ...> -2
  ...> +3
  ...> +1")
  3

  iex> Day1.solve_part_1("+1
  ...> +1
  ...> +1")
  3

  iex> Day1.solve_part_1("+1
  ...> +1
  ...> -2")
  0

  iex> Day1.solve_part_1("-1
  ...> -2
  ...> -3")
  -6
  """
  def solve_part_1(input) do
    input
    |> numbers()
    |> Enum.sum()
  end

  @doc """
  iex> Day1.solve_part_2("+1
  ...> -1")
  0

  iex> Day1.solve_part_2("+3
  ...> +3
  ...> +4
  ...> -2
  ...> -4")
  10

  iex> Day1.solve_part_2("-6
  ...> +3
  ...> +8
  ...> +5
  ...> -6")
  5

  iex> Day1.solve_part_2("+7
  ...> +7
  ...> -2
  ...> -7
  ...> -4")
  14
  """
  def solve_part_2(input) do
    input
    |> numbers()
    |> Stream.cycle()
    |> Stream.transform(0, fn number, frequency -> {[frequency], frequency + number} end)
    |> Enum.reduce_while(MapSet.new(), fn frequency, seen ->
      if MapSet.member?(seen, frequency) do
        {:halt, frequency}
      else
        {:cont, MapSet.put(seen, frequency)}
      end
    end)
  end

  defp numbers(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end
end

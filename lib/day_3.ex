defmodule Day3 do
  @behaviour Solution

  @claim_pattern ~r/#(?<id>\d+) @ (?<left>\d+),(?<top>\d+): (?<width>\d+)x(?<height>\d+)/

  @doc """
  iex> Day3.solve_part_1("#1 @ 1,3: 4x4
  ...> #2 @ 3,1: 4x4
  ...> #3 @ 5,5: 2x2")
  4
  """
  def solve_part_1(input) do
    input
    |> claims()
    |> overlapping()
    |> Enum.count()
  end

  @doc """
  iex> Day3.solve_part_2("#1 @ 1,3: 4x4
  ...> #2 @ 3,1: 4x4
  ...> #3 @ 5,5: 2x2")
  3
  """
  def solve_part_2(input) do
    claims = claims(input)
    overlapping = overlapping(claims)

    claims
    |> Enum.find(fn claim ->
      claim
      |> points()
      |> Enum.all?(&(not Map.has_key?(overlapping, &1)))
    end)
    |> Map.get(:id)
  end

  defp claims(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&Regex.named_captures(@claim_pattern, &1))
    |> Enum.map(
      &%{
        id: &1["id"] |> String.to_integer(),
        left: &1["left"] |> String.to_integer(),
        top: &1["top"] |> String.to_integer(),
        width: &1["width"] |> String.to_integer(),
        height: &1["height"] |> String.to_integer()
      }
    )
  end

  defp overlapping(claims) do
    claims
    |> Enum.flat_map(&points/1)
    |> Enum.reduce(%{}, fn point, points -> Map.update(points, point, 1, &(&1 + 1)) end)
    |> Enum.filter(fn {_, count} -> count > 1 end)
    |> Map.new()
  end

  defp points(%{left: left, top: top, width: width, height: height}) do
    for x <- left..(left + width - 1),
        y <- top..(top + height - 1) do
      {x, y}
    end
  end
end

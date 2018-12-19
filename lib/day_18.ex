defmodule Day18 do
  @behaviour Solution

  @doc """
  iex> Day18.solve_part_1(".#.#...|#.
  ...> .....#|##|
  ...> .|..|...#.
  ...> ..|#.....#
  ...> #.#|||#|#|
  ...> ...#.||...
  ...> .|....|...
  ...> ||...#|.#|
  ...> |.||||..|.
  ...> ...#.|..|.")
  1147
  """
  def solve_part_1(input) do
    solve(input, 10)
  end

  @doc """
  This does not work. :(
  """
  def solve_part_2(input) do
    solve(input, 1_000_000_000)
  end

  def solve(input, gen_count) do
    first_acres = acres(input)

    last_acres =
      0..(gen_count - 1)
      |> Enum.reduce_while({first_acres, %{}}, fn curr_gen, {acres, all_acres} ->
        next_acres = Enum.into(acres, %{}, &next(&1, acres))

        case all_acres do
          %{^next_acres => prev_gen} ->
            {:halt, predict(all_acres, gen_count, curr_gen, prev_gen)}

          all_acres ->
            {:cont, {next_acres, Map.put(all_acres, next_acres, curr_gen)}}
        end
      end)
      |> elem(0)
      |> Map.values()

    count_acres(last_acres, :wooded) * count_acres(last_acres, :lumberyard)
  end

  def acres(input) do
    all_acres =
      input
      |> String.split("\n")
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.graphemes/1)
      |> Stream.map(fn acres -> Enum.map(acres, &acre/1) end)
      |> Stream.map(&Enum.with_index/1)
      |> Stream.with_index()

    for {acres, y} <- all_acres,
        {acre, x} <- acres,
        into: %{} do
      {{x, y}, acre}
    end
  end

  defp acre("."), do: :open
  defp acre("|"), do: :wooded
  defp acre("#"), do: :lumberyard

  defp next({point, acre}, acres) do
    next_acre =
      case {acre, adjacent_counts(point, acres)} do
        {:open, %{wooded: w}} when w >= 3 -> :wooded
        {:wooded, %{lumberyard: l}} when l >= 3 -> :lumberyard
        {:lumberyard, %{lumberyard: l, wooded: w}} when l > 0 and w > 0 -> :lumberyard
        {:lumberyard, _} -> :open
        {acre, _} -> acre
      end

    {point, next_acre}
  end

  defp adjacent_counts({x, y}, acres) do
    for x_adj <- (x - 1)..(x + 1),
        y_adj <- (y - 1)..(y + 1),
        {x_adj, y_adj} != {x, y} do
      {x_adj, y_adj}
    end
    |> Enum.group_by(&Map.get(acres, &1))
    |> Enum.into(%{}, fn {acre, adjacent} -> {acre, length(adjacent)} end)
  end

  defp predict(all_acres, gen_count, curr_gen, prev_gen) do
    diff = curr_gen - prev_gen
    backtrack = rem(gen_count - curr_gen, diff)
    target_gen = curr_gen - backtrack

    Enum.find(all_acres, &match?({_, ^target_gen}, &1))
  end

  defp count_acres(acres, type) do
    acres
    |> Enum.filter(&match?(^type, &1))
    |> length()
  end
end

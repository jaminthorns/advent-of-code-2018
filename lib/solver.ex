defmodule Solver do
  @doc """
  Solve a puzzle for a given day.

  Calls the `solve/1` function on the `DayN` module using the input from the
  `inputs/day_n.txt` file.
  """
  def solve(day, part) do
    input = read_input(day)
    module = day_module(day)

    case part do
      1 -> module.solve_part_1(input)
      2 -> module.solve_part_2(input)
    end
  end

  defp read_input(day) do
    "input/day_#{day}.txt"
    |> File.read!()
    |> String.trim()
  end

  defp day_module(day) do
    String.to_atom("Elixir.Day#{day}")
  end
end

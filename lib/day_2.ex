defmodule Day2 do
  @behaviour Solution

  @doc """
  iex> Day2.solve_part_1("abcdef
  ...> bababc
  ...> abbcde
  ...> abcccd
  ...> aabcdd
  ...> abcdee
  ...> ababab")
  12
  """
  def solve_part_1(input) do
    occurrences =
      input
      |> ids()
      |> Enum.map(&occurences/1)
      |> Enum.map(&Map.values/1)

    score(occurrences, 2) * score(occurrences, 3)
  end

  @doc """
  iex> Day2.solve_part_2("abcde
  ...> fghij
  ...> klmno
  ...> pqrst
  ...> fguij
  ...> axcye
  ...> wvxyz")
  "fgij"
  """
  def solve_part_2(input) do
    indexed_ids = input |> ids() |> Enum.with_index()

    for {id_a, index_a} <- indexed_ids,
        {id_b, index_b} <- indexed_ids,
        index_a < index_b do
      {id_a, id_b}
    end
    |> Enum.find(&(difference(&1) == 1))
    |> common()
    |> Enum.join()
  end

  defp ids(input) do
    input
    |> String.split()
    |> Enum.map(&String.graphemes/1)
  end

  defp occurences(ids) do
    Enum.reduce(ids, %{}, &Map.update(&2, &1, 1, fn x -> x + 1 end))
  end

  defp score(occurrences, amount) do
    occurrences
    |> Enum.map(&if(Enum.member?(&1, amount), do: 1, else: 0))
    |> Enum.sum()
  end

  defp difference({id_a, id_b}) do
    id_a
    |> Enum.zip(id_b)
    |> Enum.filter(fn {char_a, char_b} -> char_a != char_b end)
    |> length()
  end

  defp common({id_a, id_b}) do
    id_a
    |> Enum.zip(id_b)
    |> Enum.filter(fn {char_a, char_b} -> char_a == char_b end)
    |> Enum.map(&elem(&1, 0))
  end
end

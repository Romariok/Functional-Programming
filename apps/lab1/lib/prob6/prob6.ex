defmodule Prob6 do
  @moduledoc """
  6th problem from Euler Project Archive
  """

  @doc """
  Monolitchic implementation with tail recursion
  """
  def tail_recursion do
    [sum, sum_of_sq] = sum_n_sq_tail_rec(100, 0, 0)
    :math.pow(sum, 2) - sum_of_sq
  end

  defp sum_n_sq_tail_rec(0, sum, sum_of_sq), do: [sum, sum_of_sq]

  defp sum_n_sq_tail_rec(n, sum, sum_of_sq),
    do: sum_n_sq_tail_rec(n - 1, sum + n, sum_of_sq + n * n)

  @doc """
  Monolitchic implementation with recursion
  """
  def recursion do
    :math.pow(Enum.sum(1..100), 2) - sum_of_sq_rec(100)
  end

  defp sum_of_sq_rec(1), do: 1

  defp sum_of_sq_rec(n), do: n * n + sum_of_sq_rec(n - 1)

  @doc """
  Modular implementation with sequence generation and reduce
  """
  def modular do
    sq_of_sum =
      sequence_generator(100)
      |> Enum.reduce(0, &(&1 + &2))

    sum_of_sq =
      sequence_generator(100)
      |> Enum.reduce(0, fn x, acc -> acc + x * x end)

    :math.pow(sq_of_sum, 2) - sum_of_sq
  end

  defp sequence_generator(n), do: 1..n

  @doc """
  Sequence generation using map
  """
  def seq_gen_map  do
    sq_of_sum =
      sequence_generator(100)
      |> Enum.sum()

    sum_of_sq =
      sequence_generator(100)
      |> Stream.map(&(&1 * &1))
      |> Enum.sum()

    :math.pow(sq_of_sum, 2) - sum_of_sq
  end

  @doc """
  Infinite structures and Lazy
  """
  def inf_struct_lazy do
    sq_of_sum =
      Stream.iterate(1, &(&1 + 1))
      |> Stream.take(100)
      |> Enum.sum()

    sum_of_sq =
      Stream.iterate(1, &(&1 + 1))
      |> Stream.take(100)
      |> Stream.map(&(&1 * &1))
      |> Enum.sum()

    :math.pow(sq_of_sum, 2) - sum_of_sq
  end
end

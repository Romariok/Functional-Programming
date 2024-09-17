defmodule Prob25 do
  @moduledoc """
  25th problem from Euler Project Archive
  """
  @limit 1000
  @doc """
  Monolitchic implementation with tail recursion
  """
  def tail_recursion do
    exact_fib_num_tail_rec(1, 1, 2)
  end

  def exact_fib_num_tail_rec(prev, current, index) do
    if length(Integer.digits(current)) >= @limit do
      index
    else
      exact_fib_num_tail_rec(current, current + prev, index + 1)
    end
  end

  @doc """
  Monolitchic implementation with recursion
  """
  def recursion do
    exact_fib_num_rec(1, 1)
  end

  def exact_fib_num_rec(prev, current) do
    if length(Integer.digits(current)) >= @limit do
      2
    else
      exact_fib_num_rec(current, current + prev) + 1
    end
  end

  @doc """
  Modular implementation with fold, filter, reduce
  """
  def modular do
    Stream.unfold({1, 1}, fn {a, b} -> {a, {b, a + b}} end)
    |> Stream.take_while(&(length(Integer.digits(&1)) < @limit))
    |> Enum.count()
    |> Kernel.+(1)
  end

  @doc """
  Sequence generation using map
  """
  def seq_gen_map do
    Stream.unfold({1, 1}, fn {a, b} -> {a, {b, a + b}} end)
    |> Stream.map(fn fib -> fib end)
    |> Stream.take_while(&(length(Integer.digits(&1)) < @limit))
    |> Enum.count()
    |> Kernel.+(1)
  end

  @doc """
  Infinite structures and Lazy
  """
  def inf_struct_lazy do
    Stream.iterate({1, 1}, fn {a, b} -> {b, a + b} end)
    |> Stream.map(fn {a, _b} -> a end)
    |> Stream.take_while(&(length(Integer.digits(&1)) < @limit))
    |> Enum.count()
    |> Kernel.+(1)
  end
end

defmodule Interpolation.Linear do
  @moduledoc """
  Implements Linear Interpolation
  """
  @required_points_count 2

  def calculate(known_points, points_to_calculate) do
    do_calculate(known_points, points_to_calculate, [])
  end

  def get_name, do: "Linear"
  def get_required_points_count, do: @required_points_count

  defp do_calculate(_, [], result), do: Enum.reverse(result)

  defp do_calculate([{x1, y1}, {x2, y2}] = known_points, [x | rest], result) do
    a = (y2 - y1) / (x2 - x1)
    b = y1 - a * x1
    do_calculate(known_points, rest, [{x, a * x + b} | result])
  end
end

defmodule Interpolation.Lagrange do
  @moduledoc """
  Implements Lagrange Interpolation
  """

  @required_points_count 4

  def calculate(known_points, points_to_calculate) do
    do_calculate(known_points, points_to_calculate, [])
  end

  def get_name, do: "Lagrange"

  def get_required_points_count, do: @required_points_count

  defp do_calculate(_, [], result), do: Enum.reverse(result)

  defp do_calculate(known_points, [x | rest], result),
    do: do_calculate(known_points, rest, [{x, calculate_y_value(x, known_points)} | result])

  defp calculate_y_value(x, known_points) do
    known_points
    |> Enum.map(fn {xj, yj} ->
      yj * calculate_basis_polynomial(x, xj, known_points)
    end)
    |> Enum.sum()
  end

  defp calculate_basis_polynomial(x, xj, known_points) do
    known_points
    |> Enum.reject(fn {xm, _} -> xm == xj end)
    |> Enum.reduce(1, fn {xm, _}, acc ->
      acc * (x - xm) / (xj - xm)
    end)
  end
end

defmodule Interpolation.Newton do
  @moduledoc """
  Implements Newton Interpolation using divided differences
  """

  @required_points_count 4

  def calculate(known_points, points_to_calculate) do
    do_calculate(known_points, points_to_calculate, [])
  end

  def get_name, do: "Newton"

  def get_required_points_count, do: @required_points_count

  defp do_calculate(_, [], result), do: Enum.reverse(result)

  defp do_calculate(known_points, [x | rest], result) do
    y = newton(x, known_points)
    do_calculate(known_points, rest, [{x, y} | result])
  end

  defp newton(v, known_points) do
    n = length(known_points)
    {x_points, y_points} = Enum.unzip(known_points)

    sum = Enum.at(y_points, 0)

    Enum.reduce(1..(n - 1), sum, fn i, acc ->
      term =
        Enum.reduce(0..(i - 1), 1.0, fn j, term_acc ->
          term_acc * (v - Enum.at(x_points, j))
        end)

      acc + diff(i, 0, x_points, y_points, n) * term
    end)
  end

  defp diff(k, i, x_points, y_points, n) do
    if k == 0 do
      Enum.at(y_points, i)
    else
      (diff(k - 1, i + 1, x_points, y_points, n) - diff(k - 1, i, x_points, y_points, n)) /
        (Enum.at(x_points, i + k) - Enum.at(x_points, i))
    end
  end
end

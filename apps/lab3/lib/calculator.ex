defmodule Calculator do
  @moduledoc """
  Recieves new point and sends approximated array with new point
  """
  def start(pid, opts) do
    spawn(fn ->
      loop(pid, [], opts)
    end)
  end

  defp loop(pid, points, opts) do
    points =
      receive do
        {:point, point} -> Enum.reverse([point | Enum.reverse(points)])
      end

    method = Keyword.get(opts, :method)
    method2 = Keyword.get(opts, :method2)
    step = Keyword.get(opts, :step)

    handle_method(pid, method, points, step)

    if method2, do: handle_method(pid, method2, points, step)

    loop(pid, points, opts)
  end

  defp handle_method(pid, method, points, step) do
    if length(points) >= method.get_required_points_count() do
      sliced_points =
        Enum.slice(
          points,
          (length(points) - method.get_required_points_count())..(length(points) - 1)
        )

      generated_points = Generator.generate(sliced_points, step)
      send(pid, {method, method.calculate(sliced_points, generated_points)})
    end
  end
end

defmodule Generator do
  @moduledoc """
  Generates points. Receives start point, end point and step
  """

  def generate(points, step) do
    [{start_x, _}, {end_x, _}] = [List.first(points), List.last(points)]
    generate_points(start_x, end_x, step)
  end

  defp generate_points(start_x, end_x, step) do
    Stream.iterate(start_x, &(&1 + step))
    |> Stream.take_while(&(&1 <= end_x + step))
    |> Enum.to_list()
  end
end

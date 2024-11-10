defmodule InputParser do
  @moduledoc """
    Parses input
  """
  def start(pid) do
    IO.puts("Input of first 2 points (Format: X Y):\n")
    loop_input(pid, nil)
  end

  defp loop_input(pid, prev_point_x) do
    input = String.trim(IO.gets(""))

    if input == "exit" do
      IO.puts("Exit")
      System.halt()
    end

    {validation_result, parsed_input} = validate_input(input)

    if validation_result == :error do
      IO.puts(parsed_input)
      loop_input(pid, prev_point_x)
    else
      {x, y} = parsed_input

      if prev_point_x == nil do
        send(pid, {:point, {x, y}})
        loop_input(pid, x)
      end

      if prev_point_x < x do
        send(pid, {:point, {x, y}})
        loop_input(pid, x)
      else
        IO.puts("X value must be greater than previous X value")
        loop_input(pid, prev_point_x)
      end
    end
  end

  defp validate_input(input) do
    input = String.split(String.replace(input, ~r"\s{2,}", " "), " ")

    if length(input) != 2 do
      {:error, "Point must have 2 coordinates"}
    else
      x_input = Float.parse(Enum.at(input, 0))
      y_input = Float.parse(Enum.at(input, 1))

      if x_input == :error or y_input == :error do
        {:error, "Invalid coordinates"}
      else
        {x, _} = x_input
        {y, _} = y_input
        {:ok, {x, y}}
      end
    end
  end
end

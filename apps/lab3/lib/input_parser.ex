defmodule InputParser do
  def start(pid) do
    loop_input(pid, nil)
  end

  defp loop_input(pid, prev_point_x) do
    input = String.trim(IO.gets(""))

    if input == "q" do
      IO.puts("Exit program")
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
      else
        if prev_point_x < x do
          send(pid, {:point, {x, y}})
          loop_input(pid, x)
        else
          IO.puts("X value must be greater than previous X value")
          loop_input(pid, prev_point_x)
        end
      end
    end
  end

  defp validate_input(input) do
    if length(input) != 2 do
      {:error, "Point must have 2 coordinates"}
    else
      x_result = Float.parse(Enum.at(input, 0))
      y_result = Float.parse(Enum.at(input, 1))

      if x_result == :error or y_result == :error do
        {:error, "Invalid coordinates"}
      else
        x = x_result.value
        y = y_result.value
        {:ok, {x, y}}
      end
    end
  end
end

defmodule Printer do
  @moduledoc """
  Modult that recieves points and prints out to console
  """

  def start(opts) do
    spawn(fn -> loop(opts) end)
  end

  def loop(opts) do
    receive do
      {method, points} ->
        step = Keyword.get(opts, :step)
        IO.puts("\n\n==============================================\n\n")
        IO.puts("#{method.get_name()} (go with step #{step})")
        Enum.each(points, fn {x, _} -> IO.write("#{Float.round(x, 2)}  ") end)
        IO.write("\n")
        Enum.each(points, fn {_, y} -> IO.write("#{Float.round(y, 2)}  ") end)
        IO.write("\n\n")
    end

    loop(opts)
  end
end

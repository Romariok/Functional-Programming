defmodule ArgsParser do
  @moduledoc """
  Parses input flags
  """

  @available_methods ["linear", "lagrange", "newton"]
  def parse_args(args) do
    {opts, _args, invalid} = parse_options(args)

    if opts[:help], do: print_help()

    if invalid != [] do
      handle_invalid_arguments(invalid)
    end

    opts
    |> ensure_step_option()
    |> validate_and_set_method_option()
    |> validate_and_set_method2_option()
  end

  def print_help do
    IO.puts("""
    Использование: mix run start.exs [опции]
    Опции:
    -h, --help Показать это сообщение
    -s, --step Шаг для интерполяции
    -m, --method Первый метод интерполяции
    --method2 Второй метод интерполяции
    Методы:
    linear - линейная интерполяция
    lagrange - интерполяция полиномом Лагранжа
    gauss - интерполяция полиномом Гаусса
    """)

    System.halt(0)
  end

  defp handle_invalid_arguments(invalid) do
    IO.puts("Ошибка: неверные аргументы #{inspect(invalid)}")
    System.halt(1)
  end

  defp parse_options(args) do
    OptionParser.parse(args,
      switches: [help: :boolean, step: :float, method: :string, method2: :string],
      aliases: [h: :help, s: :step, m: :method]
    )
  end

  defp ensure_step_option(opts) do
    if opts[:step] do
      if opts[:step] <= 0 do
        IO.puts("Ошибка: шаг должен быть положительным числом")
        System.halt(1)
      end

      opts
    else
      Keyword.put(opts, :step, 1)
    end
  end

  defp validate_and_set_method_option(opts) do
    if opts[:method] do
      if opts[:method] not in @available_methods do
        IO.puts("Ошибка: неверный метод интерполяции")
        System.halt(1)
      end

      method_module =
        case opts[:method] do
          "linear" -> Interpolation.Linear
          "lagrange" -> Interpolation.Lagrange
          "newton" -> Interpolation.Newton
        end

      Keyword.put(opts, :method, method_module)
    else
      Keyword.put(opts, :method, Interpolation.Lagrange)
    end
  end

  defp validate_and_set_method2_option(opts) do
    if opts[:method2] do
      if opts[:method2] not in @available_methods do
        IO.puts("Ошибка: неверный второй метод интерполяции")
        System.halt(1)
      end

      method2_module =
        case opts[:method2] do
          "linear" -> Interpolation.Linear
          "lagrange" -> Interpolation.Lagrange
          "newton" -> Interpolation.Newton
        end

      Keyword.put(opts, :method2, method2_module)
    else
      opts
    end
  end
end

defmodule Main do
  def main(args) do
    {opts, _, invalid} =
      OptionParser.parse(args,
        switches: [help: :boolean, step: :float, method: :string, method2: :string],
        aliases: [h: :help, s: :step, m: :method, m2: :method2]
      )

    if opts[:help] do
      IO.puts("Использование: mix run start.exs [опции]
      Опции:
        -h, --help     Показать это сообщение
        -s, --step     Шаг для интерполяции
        -m, --method Первый метод интерполяции
        -m2, --method2 Второй метод интерполяции

      Методы:
        linear - линейная интерполяция
        lagrange - интерполяция полиномом Лагранжа
        gauss - интерполяция полиномом Гаусса")
      System.halt(0)
    end

    if invalid != [] do
      IO.puts("Ошибка: неверные аргументы #{inspect(invalid)}")
      System.halt(1)
    end

    if opts[:step] != nil do
      if opts[:step] <= 0 do
        IO.puts("Ошибка: шаг должен быть положительным числом")
        System.halt(1)
      end
    else
      ^opts = Keyword.put(opts, :step, 0.01)
    end

    if opts[:method] != nil do
      if opts[:method] not in ["linear", "lagrange", "gauss"] do
        IO.puts("Ошибка: неверный метод интерполяции")
        System.halt(1)
      end

      if opts[:method2] != nil do
        if opts[:method2] not in ["linear", "lagrange", "gauss"] do
          IO.puts("Ошибка: неверный второй метод интерполяции")
          System.halt(1)
        end
      end
    else
      ^opts = Keyword.put(opts, :method, "lagrange")
    end

    cli(opts)
  end

  def cli(opts) do
    IO.puts("Hello, world!")
  end
end

# Лабораторная работа №1

- Вариант: 6, 25

---

Цель: освоить базовые приёмы и абстракции функционального программирования: функции, поток управления и поток данных, сопоставление с образцом, рекурсия, свёртка, отображение, работа с функциями как с данными, списки.

В рамках лабораторной работы вам предлагается решить несколько задач [проекта Эйлер](https://projecteuler.net/archives). Список задач -- ваш вариант.

Для каждой проблемы должно быть представлено несколько решений:

1. монолитные реализации с использованием:
   - хвостовой рекурсии;
   - рекурсии (вариант с хвостовой рекурсией не является примером рекурсии);
2. модульной реализации, где явно разделена генерация последовательности, фильтрация и свёртка (должны использоваться функции reduce/fold, filter и аналогичные);
3. генерация последовательности при помощи отображения (map);
4. работа со спец. синтаксисом для циклов (где применимо);
5. работа с бесконечными списками для языков, поддерживающих ленивые коллекции или итераторы как часть языка (к примеру Haskell, Clojure);
6. реализация на любом удобном для вас традиционном языке программирования для сравнения.

Требуется использовать идиоматичный для технологии стиль программирования.

Содержание отчёта:

- титульный лист;
- описание проблемы;
- ключевые элементы реализации с минимальными комментариями;
- выводы (отзыв об использованных приёмах программирования).

Примечания:

- необходимо понимание разницы между ленивыми коллекциями и итераторами;
- нужно знать особенности используемой технологии и того, как работают использованные вами приёмы.

---

## Проблема №6. Sum Square Difference

> The sum of the squares of the first ten natural numbers is,
> $$1^2+2^2+\ldots+10^2=385.$$
> The square of the sum of the first ten natural numbers is,
> $$(1+2+\ldots+10)^2 = 55^2 = 3025$$
> Hence the difference between the sum of the squares of the first ten natural numbers and the square of the sum is
> $3025 - 385 = 2640$.
>
> Find the difference between the sum of the squares of the first one hundred natural numbers and the square of the sum.

### Традиционное решение

```python
def prob6():
   sum_of_sq = sum(natural_number**2 for natural_number in range(1, 101))
   sq_of_sum = sum(natural_number for natural_number in range(1, 101))**2
   return sq_of_sum - sum_of_sq
```

### Хвостовая рекурсия

```elixir
def tail_recursion() do
   [sum, sum_of_sq] = sum_n_sq_tail_rec(100)
   :math.pow(sum, 2) - sum_of_sq
end

def sum_n_sq_tail_rec(n), do: sum_n_sq_tail_rec(n, 0, 0)

defp sum_n_sq_tail_rec(0, sum, sum_of_sq), do: [sum, sum_of_sq]

defp sum_n_sq_tail_rec(n, sum, sum_of_sq),
   do: sum_n_sq_tail_rec(n - 1, sum + n, sum_of_sq + n * n)
```

### Рекурсия

```elixir
def recursion() do
   :math.pow(Enum.sum(1..100), 2) - sum_of_sq_rec(100)
end

defp sum_of_sq_rec(1), do: 1

defp sum_of_sq_rec(n), do: n * n + sum_of_sq_rec(n - 1)
```

### Модульная реализация (Sequence generator, reduce)

```elixir
def modular() do
   sq_of_sum =
      sequence_generator(100)
      |> Enum.reduce(0, &(&1 + &2))

   sum_of_sq =
      sequence_generator(100)
      |> Enum.reduce(0, fn x, acc -> acc + x * x end)

   :math.pow(sq_of_sum, 2) - sum_of_sq
end

defp sequence_generator(n), do: 1..n
```

### Генерация последовательности при помощи `map`

```elixir
def seq_gen_map() do
   sq_of_sum =
      sequence_generator(100)
      |> Enum.sum()

   sum_of_sq =
      sequence_generator(100)
      |> Stream.map(&(&1 * &1))
      |> Enum.sum()

   :math.pow(sq_of_sum, 2) - sum_of_sq
end
```

### Бесконечные структуры, ленивыое вычисление (Stream)

```elixir
def inf_struct_lazy() do
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
```

---

## Проблема №25. 1000-digit Fibonacci Number

> The Fibonacci sequence is defined by the recurrence relation:
> 
> $F_n = F_{n-1} + F_{n-2}$, where $F_1 = 1$ and $F_2 = 1$
>
> Hence the first $12$ terms will be:
> $$F_1 = 1$$
> $$F_2 = 1$$
> $$F_3 = 2$$
> $$\vdots$$
> $$F_{12} = 144$$
> The $12$th term, $F_{12}$ is the first term to contain three digits.
>
> What is the index of the first term in the Fibonacci sequence to contain $1000$ digits?

### Традиционное решение

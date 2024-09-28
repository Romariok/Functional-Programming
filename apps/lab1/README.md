# Лабораторная работа №1

- Вариант: 6, 25
- Студент: `Кобелев Роман Павлович`
- Группа: `P3312`
- ИСУ: `368308`
  
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
def tail_recursion do
   [sum, sum_of_sq] = sum_n_sq_tail_rec(100, 0, 0)
   :math.pow(sum, 2) - sum_of_sq
end

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

```python
fib1, fib2 = 1, 1
it = 2
while len(str(fib2))<1000:
   tmp = fib2+fib1
   fib1 = fib2
   fib2 = tmp
   it+=1
print(it)
```

### Хвостовая рекурсия

```elixir
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
```

### Рекурсия

```elixir
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
```

### Модульная реализация (Sequence generator, reduce)

```elixir
def modular do
   Stream.unfold({1, 1}, fn {a, b} -> {a, {b, a + b}} end)
   |> Stream.take_while(&(length(Integer.digits(&1)) < @limit))
   |> Enum.count()
   |> Kernel.+(1)
end
```

### Генерация последовательности при помощи `map`

```elixir
def seq_gen_map do
   Stream.unfold({1, 1}, fn {a, b} -> {a, {b, a + b}} end)
   |> Stream.map(fn fib -> fib end)
   |> Stream.take_while(&(length(Integer.digits(&1)) < @limit))
   |> Enum.count()
   |> Kernel.+(1)
end
```

### Бесконечные структуры, ленивыое вычисление (Stream)

```elixir
def inf_struct_lazy do
   Stream.iterate({1, 1}, fn {a, b} -> {b, a + b} end)
   |> Stream.map(fn {a, _b} -> a end)
   |> Stream.take_while(&(length(Integer.digits(&1)) < @limit))
   |> Enum.count()
   |> Kernel.+(1)
end
```

## Вывод

По итогам работы я ознакомился с основным синтаксисом и принципами написания програм на языке программирования `Elixir`. Решил разными сопсобами две задачи из архива Проекта Эйлера.

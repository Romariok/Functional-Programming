defmodule Lab2Test do
  alias AVLDict.Dictionary
  alias AVLDict.Node
  use ExUnit.Case
  doctest AVLDict

  @empty_node %Node{key: nil, value: nil, left: nil, right: nil, height: 0}

  def balance_check(%Node{key: nil, value: nil, height: height, left: nil, right: nil}),
    do: height == 0

  def balance_check(%Node{
        key: _key,
        value: _value,
        height: height,
        left: %Node{height: left_height} = left,
        right: %Node{height: right_height} = right
      }) do
    balance_check(left) and balance_check(right) and height == max(left_height, right_height) + 1 and
      right_height - left_height < 2 and -2 < right_height - left_height
  end

  def insert_all(l) do
    r =
      :lists.foldl(
        fn {key, value}, acc ->
          cur = Dictionary.insert(acc, key, value)
          assert balance_check(cur) == true
        end,
        @empty_node,
        l
      )

    list_r = Dictionary.to_list(r)
    assert ^list_r = :lists.usort(l)
  end

  # Добавление

  test "One Node" do
    node = Dictionary.insert(@empty_node, 1, "value1")

    expected_node = %Node{
      key: 1,
      value: "value1",
      height: 1,
      left: @empty_node,
      right: @empty_node
    }

    assert node == expected_node and Dictionary.find(0, node) == :not_found and
             Dictionary.find(1, node) == {1, "value1"}
  end

  test "Two Node" do
    node1 = Dictionary.insert(@empty_node, 1, "value1")
    node2 = Dictionary.insert(node1, 2, "value2")

    expected_node = %Node{
      key: 1,
      value: "value1",
      height: 2,
      left: @empty_node,
      right: %Node{key: 2, value: "value2", height: 1, left: @empty_node, right: @empty_node}
    }

    assert node2 == expected_node
  end

  test "Six Node" do
    l = [{1, "value1"}, {2, "value2"}, {3, "value3"}, {4, "value4"}, {5, "value5"}, {6, "value6"}]

    expected_node = %Node{
      key: 4,
      value: "value4",
      height: 3,
      left: %Node{
        key: 2,
        value: "value2",
        height: 2,
        left: %Node{key: 1, value: "value1", height: 1, left: @empty_node, right: @empty_node},
        right: %Node{key: 3, value: "value3", height: 1, left: @empty_node, right: @empty_node}
      },
      right: %Node{
        key: 5,
        value: "value5",
        height: 2,
        left: @empty_node,
        right: %Node{key: 6, value: "value6", height: 1, left: @empty_node, right: @empty_node}
      }
    }

    assert Dictionary.equal_tree(Dictionary.from_list(l), expected_node) == true
  end

  test "Big Node" do
    l = Enum.map(1..10_000, fn x -> {x, "value#{x}"} end)
    t = Dictionary.from_list(l)
    balance_check(t)
    assert Dictionary.to_list(t) == :lists.usort(l)
  end

  # Удаление

  test "One Node Remove" do
    t = Dictionary.from_list([{1, "value1"}])
    assert Dictionary.remove(1, t) == @empty_node
  end

  test "One From Two Node Remove" do
    t = Dictionary.from_list([{1, "value1"}, {2, "value2"}])
    assert Dictionary.to_list(Dictionary.remove(1, t)) == [{2, "value2"}]
  end

  test "Two Node Remove" do
    t = Dictionary.from_list([{1, "value1"}, {2, "value2"}, {3, "value3"}])

    assert Dictionary.to_list(Dictionary.remove(2, t)) == [{1, "value1"}, {3, "value3"}] and
             Dictionary.to_list(Dictionary.remove(1, t)) == [{2, "value2"}, {3, "value3"}]
  end

  test "Four Node Remove" do
    t = Dictionary.from_list([{1, "value1"}, {0, "value0"}, {3, "value3"}, {4, "value4"}])

    assert Dictionary.to_list(Dictionary.remove(3, t)) == [
             {0, "value0"},
             {1, "value1"},
             {4, "value4"}
           ]
  end

  test "Not Found Remove" do
    t = Dictionary.from_list([{1, "value1"}, {2, "value2"}, {3, "value3"}])
    assert Dictionary.remove(52, t) == t
  end

  def remove_all(l, t) do
    {empty_t, _} =
      :lists.foldl(
        fn {k, _v}, {t_acc, l_acc} ->
          newt = Dictionary.remove(k, t_acc)
          [_ | newl] = l_acc
          assert balance_check(newt) == true
          assert :lists.usort(newl) == Dictionary.to_list(newt)
          {newt, newl}
        end,
        {t, l},
        l
      )

    assert empty_t == @empty_node
  end

  test "Remove All" do
    l = [{1, "value1"}, {2, "value2"}, {3, "value3"}, {0, "value0"}]
    t = Dictionary.from_list(l)
    remove_all(l, t)
  end

  # Проверка свойства моноида
  # Нейтральный элемент

  def monoid_neutral_elem(t_size) do
    t = Dictionary.from_list(Enum.map(1..t_size, fn _ -> {:rand.uniform(30), 0} end))
    r = Dictionary.merge(t, @empty_node)
    assert Dictionary.to_list(t) == Dictionary.to_list(r)
    r2 = Dictionary.merge(@empty_node, t)
    assert Dictionary.to_list(t) == Dictionary.to_list(r2)
  end

  test "Monoid Neutral Element" do
    Enum.map(1..10_000, fn _ -> monoid_neutral_elem(:rand.uniform(1000) - 1) end)
  end

  # Ассоциативность операции умножения - слияние деревьев

  def associativity(t1_size, t2_size, t3_size) do
    t1 = Dictionary.from_list(Enum.map(1..t1_size, fn _ -> {:rand.uniform(30), :rand.uniform(100)} end))
    t2 = Dictionary.from_list(Enum.map(1..t2_size, fn _ -> {:rand.uniform(30), :rand.uniform(100)} end))
    t3 = Dictionary.from_list(Enum.map(1..t3_size, fn _ -> {:rand.uniform(30), :rand.uniform(100)} end))

    r1 = Dictionary.merge(t1, Dictionary.merge(t2, t3))
    r2 = Dictionary.merge(Dictionary.merge(t1, t2), t3)

    assert Dictionary.to_list(r1) == Dictionary.to_list(r2)
  end

  test "Small Monoid Test" do
    Enum.map(1..10_000, fn _ -> associativity(:rand.uniform(10) - 1, :rand.uniform(10) - 1, :rand.uniform(10) - 1) end)
  end

  test "Medium Monoid Test" do
    Enum.map(1..10_000, fn _ -> associativity(:rand.uniform(100) - 1, :rand.uniform(100) - 1, :rand.uniform(100) - 1) end)
  end

  test "Big Monoid Test" do
    Enum.map(1..10_000, fn _ -> associativity(:rand.uniform(1000) - 1, :rand.uniform(1000) - 1, :rand.uniform(1000) - 1) end)
  end
end

defmodule Lab1Test do
  use ExUnit.Case
  doctest Prob6

  @expected_value_6 25_164_150

  test "Problem 6: tail recursion" do
    assert Prob6.tail_recursion() == @expected_value_6
  end

  test "Problem 6: recursion" do
    assert Prob6.recursion() == @expected_value_6
  end

  test "Problem 6: modular" do
    assert Prob6.modular() == @expected_value_6
  end

  test "Problem 6: sequence generation using map" do
    assert Prob6.seq_gen_map() == @expected_value_6
  end

  test "Problem 6: infinite structures and Lazy" do
    assert Prob6.inf_struct_lazy() == @expected_value_6
  end
end

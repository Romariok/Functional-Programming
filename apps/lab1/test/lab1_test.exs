defmodule Lab1Test do
  use ExUnit.Case
  doctest Prob6
  doctest Prob25

  @expected_value_6 25_164_150
  @expected_value_25 4782

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

  test "Problem 25: tail recursion" do
    assert Prob25.tail_recursion() == @expected_value_25
  end

  test "Problem 25: recursion" do
    assert Prob25.recursion() == @expected_value_25
  end

  test "Problem 25: modular" do
    assert Prob25.modular() == @expected_value_25
  end

  test "Problem 25: sequence generator using map" do
    assert Prob25.seq_gen_map() == @expected_value_25
  end

  test "Problem 25: infinite structures and Lazy" do
    assert Prob25.inf_struct_lazy() == @expected_value_25
  end
end

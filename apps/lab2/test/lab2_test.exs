defmodule Lab2Test do
  alias AVLDict.Dictionary
  alias AVLDict.Node
  use ExUnit.Case
  doctest AVLDict

  test "Height of node with no child" do
    node_height = Dictionary.height(Node.new())
    assert node_height == 1
  end

  test "Height of node with one child" do
    node_height = Dictionary.height(%Node{right: Node.new()})
    assert node_height == 2
  end

  test "Height of node with two childs with heights 2 and 3" do
    node_height =
      Dictionary.height(%Node{
        Node.new()
        | right: %Node{left: Node.new()},
          left: %Node{left: %Node{right: Node.new()}}
      })

    assert node_height == 4
  end

  test "Left rotation" do
    node = %Node{
      key: 1,
      value: "value1",
      left: %Node{key: 2, value: "value2", height: 1},
      right: %Node{
        key: 3,
        value: "value3",
        left: %Node{key: 5, value: "value5", height: 1},
        right: %Node{key: 4, value: "value4", height: 1},
        height: 2
      },
      height: 3
    }

    expected_node = %Node{
      key: 3,
      value: "value3",
      left: %Node{
        key: 1,
        value: "value1",
        left: %Node{key: 2, value: "value2", height: 1},
        right: %Node{key: 5, value: "value5", height: 1},
        height: 2
      },
      right: %Node{key: 4, value: "value4", height: 1},
      height: 3
    }

    assert %Node{
             Dictionary.left_rotate(node)
             | height: Dictionary.height(Dictionary.left_rotate(node))
           } == expected_node
  end

  test "Right rotation" do
    node = %Node{
      key: 3,
      value: "value3",
      left: %Node{
        key: 1,
        value: "value1",
        left: %Node{key: 2, value: "value2", height: 1},
        right: %Node{key: 5, value: "value5", height: 1},
        height: 2
      },
      right: %Node{key: 4, value: "value4", height: 1},
      height: 3
    }

    expected_node = %Node{
      key: 1,
      value: "value1",
      left: %Node{key: 2, value: "value2", height: 1},
      right: %Node{
        key: 3,
        value: "value3",
        left: %Node{key: 5, value: "value5", height: 1},
        right: %Node{key: 4, value: "value4", height: 1},
        height: 2
      },
      height: 3
    }

    assert %Node{
             Dictionary.right_rotate(node)
             | height: Dictionary.height(Dictionary.right_rotate(node))
           } == expected_node
  end

  test "Big right rotation" do
    node = %Node{
      key: 1,
      value: "value1",
      right: %Node{key: 2, value: "value2", height: 1},
      left: %Node{
        key: 3,
        value: "value3",
        left: %Node{key: 4, value: "value4", height: 1},
        right: %Node{
          key: 5,
          value: "value5",
          height: 2,
          left: %Node{key: 6, value: "value6", height: 1},
          right: %Node{key: 7, value: "value7", height: 1}
        },
        height: 3
      },
      height: 4
    }

    expected_node = %Node{
      key: 5,
      value: "value5",
      left: %Node{
        key: 3,
        value: "value3",
        left: %Node{key: 4, value: "value4", height: 1},
        right: %Node{key: 6, value: "value6", height: 1},
        height: 2
      },
      right: %Node{
        key: 1,
        value: "value1",
        left: %Node{key: 7, value: "value7", height: 1},
        right: %Node{key: 2, value: "value2", height: 1},
        height: 2
      },
      height: 3
    }

    assert Dictionary.balance(node) == expected_node
  end

  test "Big left rotation" do
    node = %Node{
      key: 1,
      value: "value1",
      left: %Node{key: 2, value: "value2", height: 1},
      right: %Node{
        key: 3,
        value: "value3",
        right: %Node{key: 4, value: "value4", height: 1},
        left: %Node{
          key: 5,
          value: "value5",
          height: 2,
          left: %Node{key: 6, value: "value6", height: 1},
          right: %Node{key: 7, value: "value7", height: 1}
        },
        height: 3
      },
      height: 4
    }

    expected_node = %Node{
      key: 5,
      value: "value5",
      right: %Node{
        key: 3,
        value: "value3",
        right: %Node{key: 4, value: "value4", height: 1},
        left: %Node{key: 7, value: "value7", height: 1},
        height: 2
      },
      left: %Node{
        key: 1,
        value: "value1",
        right: %Node{key: 6, value: "value6", height: 1},
        left: %Node{key: 2, value: "value2", height: 1},
        height: 2
      },
      height: 3
    }

    assert Dictionary.balance(node) == expected_node
  end
end

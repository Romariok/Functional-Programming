defmodule AVLDict do
  @moduledoc """
  Module that implement an AVL Tree based dictionary
  """
  defmodule Node do
    defstruct [:key, :value, :left, :right, :height]

    def new() do
      %Node{key: nil, value: nil, left: nil, right: nil, height: 0}
    end

    def height(%Node{height: height}) do
      height
    end
  end

  defmodule Dictionary do
    def left_rotate(%Node{right: ptr1} = t) do
      ptr2 = ptr1.left
      ptr1 = %{ptr1 | left: %{t | right: ptr2, height: t.height - 1}}
      ptr1
    end

    def right_rotate(%Node{left: ptr1} = t) do
      ptr2 = ptr1.right
      ptr1 = %{ptr1 | right: %{t | left: ptr2, height: t.height - 1}}
      ptr1
    end

    def height(nil), do: 0

    def height(%Node{left: left, right: right}) do
      max(height(left), height(right)) + 1
    end

    def balance(%Node{left: %Node{height: leftHeight}, right: %Node{height: rightHeight}} = node)
    when abs(leftHeight - rightHeight) != 2 do
      node
    end
    def balance(%Node{left: %Node{height: leftHeight}, right: %Node{height: rightHeight}} = node) # Right rotation
    when leftHeight == rightHeight + 1 do
      %Node{right_rotate(node) | height: height(right_rotate(node))}
    end
    def balance(%Node{left: %Node{height: leftHeight}, right: %Node{height: rightHeight}} = node) # Left rotation
    when leftHeight + 1 == rightHeight do
      %Node{left_rotate(node) | height: height(left_rotate(node))}
    end
    def balance(%Node{right: %Node{left: %Node{height: rightLeftHeight}}, left: %Node{height: leftHeight}} = node) # Big left rotation
     when rightLeftHeight == leftHeight + 1 do
      new_node = %Node{node | right: %Node{right_rotate(node.right) | height: height(right_rotate(node.right))}}
      new_node = %Node{left_rotate(new_node) | height: height(left_rotate(new_node))}
      %Node{new_node | left: %Node{new_node.left | height: height(new_node.left)}}
    end
    def balance(%Node{left: %Node{right: %Node{height: leftRightHeight}}, right: %Node{height: rightHeight}} = node) # Big right rotation
     when leftRightHeight == rightHeight + 1 do
      new_node = %Node{node | left: %Node{left_rotate(node.left) | height: height(left_rotate(node.left))}}
      new_node = %Node{right_rotate(new_node) | height: height(right_rotate(new_node))}
      %Node{new_node | right: %Node{new_node.right | height: height(new_node.right)}}
    end

    def insert(nil, _key, _value), do:
      Node.new()
    def insert(%Node{key: nodeKey, value: _nodeValue} = node, key, value) when nodeKey == key, do:
      %Node{node | value: value}
    def insert(%Node{key: nodeKey, left: left} = node, key, value) when nodeKey > key do
      newSmall = insert(left, key, value)
      balance(%Node{node | left: newSmall, height: max(height(newSmall) + 1, node.height)})
    end
    def insert(%Node{key: nodeKey, right: right} = node, key, value) when nodeKey < key do
      newBig = insert(right, key, value)
      balance(%Node{node | right: newBig, height: max(height(newBig) + 1, node.height)})
    end

  end
end

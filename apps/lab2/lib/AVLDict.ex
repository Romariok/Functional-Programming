defmodule AVLDict do
  @moduledoc """
  Module that implement an AVL Tree based dictionary
  """
  defmodule Node do
    @moduledoc """
    Node of the AVL Tree
    """
    defstruct [:key, :value, :left, :right, :height]

    def new do
      %Node{key: nil, value: nil, left: nil, right: nil, height: 0}
    end

    def height(%Node{height: height}) do
      height
    end
  end

  defmodule Dictionary do
    @moduledoc """
    Dictionary that implement an AVL Tree
    """
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

    def balance(%Node{left: %Node{height: left_height}, right: %Node{height: right_height}} = node)
        when abs(left_height - right_height) != 2 do
      node
    end

    # Right rotation
    def balance(%Node{left: %Node{height: left_height}, right: %Node{height: right_height}} = node)
        when left_height == right_height + 1 do
      %Node{right_rotate(node) | height: height(right_rotate(node))}
    end

    # Left rotation
    def balance(%Node{left: %Node{height: left_height}, right: %Node{height: right_height}} = node)
        when left_height + 1 == right_height do
      %Node{left_rotate(node) | height: height(left_rotate(node))}
    end

    # Big left rotation
    def balance(
          %Node{
            right: %Node{left: %Node{height: right_left_height}},
            left: %Node{height: left_height}
          } = node
        )
        when right_left_height == left_height + 1 do
      new_node = %Node{
        node
        | right: %Node{right_rotate(node.right) | height: height(right_rotate(node.right))}
      }

      new_node = %Node{left_rotate(new_node) | height: height(left_rotate(new_node))}
      %Node{new_node | left: %Node{new_node.left | height: height(new_node.left)}}
    end

    # Big right rotation
    def balance(
          %Node{
            left: %Node{right: %Node{height: left_right_height}},
            right: %Node{height: right_height}
          } = node
        )
        when left_right_height == right_height + 1 do
      new_node = %Node{
        node
        | left: %Node{left_rotate(node.left) | height: height(left_rotate(node.left))}
      }

      new_node = %Node{right_rotate(new_node) | height: height(right_rotate(new_node))}
      %Node{new_node | right: %Node{new_node.right | height: height(new_node.right)}}
    end

    def insert(nil, _key, _value), do: Node.new()

    def insert(%Node{key: nodeKey, value: _nodeValue} = node, key, value) when nodeKey == key,
      do: %Node{node | value: value}

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

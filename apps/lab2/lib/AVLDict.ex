defmodule AVLDict do
  @moduledoc """
  Module that implement an AVL Tree based dictionary
  """
  defmodule Node do
    @moduledoc """
    Node of the AVL Tree
    """
    defstruct [:key, :value, :height, :left, :right]

    def new do
      %Node{key: nil, value: nil, left: nil, right: nil, height: 0}
    end
  end

  defmodule Dictionary do
    @moduledoc """
    Dictionary that implement an AVL Tree
    """
    @empty_node %Node{key: nil, value: nil, left: nil, right: nil, height: 0}

    def height(@empty_node), do: 0

    def height(%Node{left: left, right: right}) do
      max(height(left), height(right)) + 1
    end

    def balance(
          %Node{left: %Node{height: left_height}, right: %Node{height: right_height}} = node
        )
        when abs(left_height - right_height) != 2 do
      node
    end

    # Right rotation
    def balance(
          %Node{
            left:
              %Node{
                left: %Node{height: left_left_height} = left_left,
                right: %Node{height: left_right_height} = left_right
              } = left,
            right: %Node{height: right_height}
          } = node
        )
        when left_left_height == right_height + 1 do
      new_height_right = max(right_height, left_right_height) + 1

      %Node{
        left
        | height: max(new_height_right, left_right_height) + 1,
          right: %Node{node | height: new_height_right, left: left_right},
          left: left_left
      }
    end

    # Left rotation
    def balance(
          %Node{
            left: %Node{height: left_height},
            right:
              %Node{
                right: %Node{height: right_right_height} = right_right,
                left: %Node{height: right_left_height} =  right_left
              } = right
          } = node
        )
        when left_height + 1 == right_right_height do
      new_height_left = max(left_height, right_left_height) + 1

      %Node{
        right
        | height: max(new_height_left, right_left_height) + 1,
          left: %Node{node | height: new_height_left, right: right_left},
          right: right_right
      }
    end

    # Big right rotation
    def balance(
          %Node{
            left:
              %Node{
                right:
                  %Node{height: left_right_height, left: left_right_left, right: left_right_right} =
                    left_right,
                left: %Node{height: left_left_height} = left_left
              } = left,
            right: %Node{height: right_height}
          } = node
        )
        when left_right_height == right_height + 1 do
      %Node{
        left_right
        | height: left_left_height + 2,
          left: %Node{
            left
            | height: left_left_height + 1,
              left: left_left,
              right: left_right_left
          },
          right: %Node{node | height: left_left_height + 1, left: left_right_right}
      }
    end

    # Big left rotation
    def balance(
          %Node{
            right:
              %Node{
                left:
                  %Node{height: right_left_height, left: right_left_left, right: right_left_right} =
                    right_left,
                right: %Node{height: right_right_height} = right_right
              } = right,
            left: %Node{height: left_height}
          } = node
        )
        when right_left_height == left_height + 1 do
      %Node{
        right_left
        | height: right_right_height + 2,
          left: %Node{node | height: right_right_height + 1, right: right_left_left},
          right: %Node{
            right
            | height: right_right_height + 1,
              left: right_left_right,
              right: right_right
          }
      }
    end

    def insert(@empty_node, key, value),
      do: %Node{key: key, value: value, height: 1, left: @empty_node, right: @empty_node}

    def insert(%Node{key: node_key, value: _node_value} = node, key, value) when node_key == key,
      do: %Node{node | value: value}

    def insert(%Node{key: node_key, left: left, height: node_height} = node, key, value)
        when node_key > key do
      new_small = insert(left, key, value)
      balance(%Node{node | left: new_small, height: max(height(new_small) + 1, node_height)})
    end

    def insert(%Node{key: node_key, right: right, height: node_height} = node, key, value)
        when node_key < key do
      new_big = insert(right, key, value)
      balance(%Node{node | right: new_big, height: max(height(new_big) + 1, node_height)})
    end

    def find(_key, @empty_node), do: :not_found
    def find(key, %Node{key: key, value: value}), do: {key, value}
    def find(key, %Node{key: node_key, left: left}) when node_key > key, do: find(key, left)
    def find(key, %Node{key: node_key, right: right}) when node_key < key, do: find(key, right)

    def remove_min(%Node{key: key, value: value, height: _, left: @empty_node, right: right}) do
      {%Node{key: key, value: value, height: nil, left: nil, right: nil}, right, true}
    end

    def remove_min(%Node{key: key, value: value, height: _, left: left, right: @empty_node}) do
      {left, %Node{key: key, value: value, height: 1, left: @empty_node, right: @empty_node},
       true}
    end

    def remove_min(%Node{
          key: key,
          value: value,
          height: _,
          left: left,
          right:
            %Node{
              key: key_r,
              value: value_r,
              height: height_r,
              left: %Node{height: height_left_r} = left_r,
              right: %Node{height: height_right_r} = right_r
            } = right
        }) do
      {min, new_left, is_last_call} = remove_min(left)

      case {is_last_call, %Node{height: height_new_left} = new_left, right_r, height_r} do
        {true, @empty_node, @empty_node, 2} ->
          {min,
           %Node{
             left_r
             | height: 2,
               left: %Node{
                 key: key,
                 value: value,
                 height: 1,
                 left: @empty_node,
                 right: @empty_node
               },
               right: %Node{
                 key: key_r,
                 value: value_r,
                 height: 1,
                 left: @empty_node,
                 right: @empty_node
               }
           }, false}

        {true, @empty_node, _, _} ->
          {min,
           %Node{
             key: key_r,
             value: value_r,
             height: max(height_left_r + 1, height_right_r) + 1,
             left: %Node{
               key: key,
               value: value,
               left: @empty_node,
               right: left_r,
               height: height_left_r + 1
             },
             right: right_r
           }, false}

        _ ->
          {min,
           balance(%Node{
             key: key,
             value: value,
             height: max(height_new_left + 1, height_r) + 1,
             left: new_left,
             right: right
           }), false}
      end
    end

    def do_remove(_key, @empty_node), do: :not_found

    def do_remove(key, %Node{
          key: key,
          value: _value,
          height: _,
          left: @empty_node,
          right: @empty_node
        }),
        do: @empty_node

    def do_remove(key, %Node{key: key, value: _value, height: _, left: left, right: @empty_node}),
      do: left

    def do_remove(key, %Node{key: key, value: _value, height: _, left: @empty_node, right: right}),
      do: right

    def do_remove(key, %Node{
          key: key,
          value: _value,
          height: _,
          left: %Node{height: height_left} = left,
          right: right
        }) do
      {min, %Node{height: height_new_right} = new_right, _} = remove_min(right)

      case min do
        @empty_node ->
          @empty_node

        %Node{key: min_key, value: min_value} ->
          balance(%Node{
            key: min_key,
            value: min_value,
            left: left,
            right: new_right,
            height: max(height_left, height_new_right) + 1
          })
      end
    end

    def do_remove(target_key, %Node{
          key: key,
          value: value,
          height: _h,
          left: left,
          right: %Node{height: height_right} = right
        })
        when target_key < key do
      new_left = do_remove(target_key, left)
      case {new_left, right} do
        {:not_found, _} ->
          :not_found

        {@empty_node, @empty_node} ->
          %Node{key: key, value: value, height: 1, left: @empty_node, right: @empty_node}

        {%Node{height: height_new_left}, _} ->
          balance(%Node{
            key: key,
            value: value,
            height: max(height_new_left, height_right) + 1,
            left: new_left,
            right: right
          })
      end
    end

    def do_remove(target_key, %Node{
          key: key,
          value: value,
          height: _h,
          left: %Node{height: height_left} = left,
          right: right
        })
        when target_key > key do
      new_right = do_remove(target_key, right)
      case {left, new_right} do
        {_, :not_found}->
          :not_found

        {@empty_node, @empty_node} ->
          %Node{key: key, value: value, height: 1, left: @empty_node, right: @empty_node}

        {_, %Node{height: height_new_right}} ->
          balance(%Node{
            key: key,
            value: value,
            height: max(height_new_right, height_left) + 1,
            left: left,
            right: new_right
          })
      end
    end

    def remove(key, tree) do
      case do_remove(key, tree) do
        :not_found -> tree
        {_, new_tree, _} -> new_tree
        new_tree -> new_tree
      end
    end

    def to_list(@empty_node), do: []

    def to_list(%Node{key: key, value: value, left: left, right: right}) do
      to_list(left) ++ [{key, value}] ++ to_list(right)
    end

    def from_list(list) do
      :lists.foldl(fn {key, value}, acc -> insert(acc, key, value) end, @empty_node, list)
    end

    def map(nil, _), do: []

    def map(%Node{key: key, value: value, left: left, right: right}, fun) do
      map(left, fun) ++ [fun.({key, value})] ++ map(right, fun)
    end

    def map_tree(node, fun) do
      from_list(map(node, fun))
    end

    def foldl(@empty_node, acc, _), do: acc

    def foldl(%Node{key: key, value: value, left: left, right: right}, acc, fun) do
      foldl(right, fun.(foldl(left, acc, fun), {key, value}), fun)
    end

    def foldr(@empty_node, acc, _), do: acc

    def foldr(%Node{key: key, value: value, left: left, right: right}, acc, fun) do
      foldr(left, fun.(foldr(right, acc, fun), {key, value}), fun)
    end

    def filter(@empty_node, _), do: []

    def filter(%Node{key: key, value: value, height: _, left: left, right: right}, func) do
      case func.(key, value) do
        true -> filter(left, func) ++ [key, value] ++ filter(right, func)
        false -> filter(left, func) ++ filter(right, func)
      end
    end

    def filter_tree(tree, func), do: from_list(filter(tree, func))

    def merge(x, y) do
      foldl(y, x, fn acc, {key, value} -> insert(acc, key, value) end)
    end

    def equal_tree(x, y) do
      lenx = foldl(x, 0, fn acc, _ -> acc + 1 end)
      leny = foldl(y, 0, fn acc, _ -> acc + 1 end)

      case lenx == leny do
        false -> false
        _ -> foldl(y, true, fn acc, {key, value} -> acc and find(key, x) === {key, value} end)
      end
    end
  end
end

defmodule IsaacTest do
  use ExUnit.Case

  test "it works with no initializer" do
    ctx = Isaac.init []
    assert Isaac.next_int(ctx) == 405143795
  end

  test "It yield the correct result for seed [1,2,3,4]" do
    ctx = Isaac.init [1,2,3,4]
    assert Isaac.next_int(ctx) == -621246914
  end
end

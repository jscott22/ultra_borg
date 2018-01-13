defmodule UltraBorgTest do
  use ExUnit.Case
  doctest UltraBorg

  test "greets the world" do
    assert UltraBorg.hello() == :world
  end
end

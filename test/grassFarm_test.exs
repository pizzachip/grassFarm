defmodule GrassFarmTest do
  use ExUnit.Case
  doctest GrassFarm

  test "greets the world" do
    assert GrassFarm.hello() == :world
  end
end

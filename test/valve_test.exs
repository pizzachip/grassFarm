defmodule ValveTest do
  use ExUnit.Case
  doctest Valves.Valve

  alias Valves.Valve

  test "create a new valve" do
    assert %Valve{id: 1} ==
      %Valve{
        id: 1,
        name: "New Valve",
        gpio_port: nil
      }
  end

  test "turn on a valve" do
    assert Valve.start(1) == :ok
  end
end

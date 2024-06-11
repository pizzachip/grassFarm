defmodule ValveTest do
  use ExUnit.Case
  doctest Valves.Valve

  alias Valves.Valve

  test "create a new valve" do
    assert %Valve{id: 1} ==
      %Valve{
        id: 1,
        name: "New Valve",
        gpio_pin: nil
      }
  end
end

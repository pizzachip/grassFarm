defmodule ValveTest do
  use ExUnit.Case
  doctest GrassFarm.Valves.Valve

  alias GrassFarm.Valves.Valve

  test "create a new valve" do
    assert %Valve{id: 1} ==
      %Valve{
        id: 1,
        name: "New Valve",
        gpio_pin: nil
      }
  end
end

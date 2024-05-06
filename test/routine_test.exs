defmodule RoutineTest do
  use ExUnit.Case
  doctest GrassFarm.Routine

  alias GrassFarm.Routine

  test "creates a new routine" do
    assert %Routine{id: 1} == 
      %Routine{id: 1, name: "New Routine", zone_times: nil} 
  end

  test "launches a routine" do
    assert Routine.start() == :ok
  end

end

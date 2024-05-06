defmodule ZoneTest do
  use ExUnit.Case
  doctest GrassFarm.Zone

  alias GrassFarm.Zone

  test "create a new zone" do
    assert %Zone{id: 1} ==
      %Zone{
        id: 1,
        name: "New Zone",
        gpio_port: nil,
        status: :off
      }
  end

  test "turn on a zone" do
    assert Zone.start(1) == :ok
  end
end

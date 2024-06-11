defmodule SessionTest do
  use ExUnit.Case
  doctest Sessions.Session

  alias Sessions.Session

  test "create a new session" do
    assert %Session{valve_id: 1} ==
      %Session{
        valve_id: 1,
        minutes: 12
      }
  end
end

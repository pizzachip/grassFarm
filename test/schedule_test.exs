defmodule ScheduleTest do
  use ExUnit.Case
  doctest Sessions.Schedule

  alias Sessions.Schedule

  test "create a new empty schedule" do
    assert %Schedule{start: ~T[07:00:00]} ==
      %Schedule{
        start: ~T[07:00:00],
        sessions: []
      }
  end
end

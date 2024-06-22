defmodule ScheduleTest do
  use ExUnit.Case
  doctest Sessions.Schedule

  alias Sessions.Schedule

  @timezone "America/Chicago"

  test "create a new empty schedule" do
    assert %Schedule{start: ~T[07:00:00]} ==
      %Schedule{
        start: ~T[07:00:00],
        sessions: []
      }
  end

  test "determine start time for calculating commulative rainfall based on schedule" do
    {:ok, nowtime} = DateTime.new(~D[2024-06-16], ~T[18:05:01.001], @timezone)
    {:ok, schedule_start_time} = DateTime.new(~D[2024-06-17], ~T[07:00:00.001], @timezone)

    assert Schedule.set_cumm_rain_start(nowtime, schedule_start_time) ==
      DateTime.add(schedule_start_time, -24, :hour)
  end

  test "skip current watering based on rain" do
    past_24_rain_cm = 2.5
    past_24_avg_temp_c = 25
    raining_now = false
    current_temp_c = 20 

    assert Schedule.skip(past_24_rain_cm, past_24_avg_temp_c, raining_now, current_temp_c) == true
  end

  test "skip current watering because it is raining " do
    past_24_rain_cm = 0
    past_24_avg_temp_c = 25
    raining_now = true 
    current_temp_c = 20 

    assert Schedule.skip(past_24_rain_cm, past_24_avg_temp_c, raining_now, current_temp_c) == true
  end

  test "skip current watering because its too cold" do
    past_24_rain_cm = 0.5
    past_24_avg_temp_c = 25
    raining_now = false
    current_temp_c = 4.5 

    assert Schedule.skip(past_24_rain_cm, past_24_avg_temp_c, raining_now, current_temp_c) == true 
  end

  test "no reason to skip" do
    past_24_rain_cm = 0.5
    past_24_avg_temp_c = 25
    raining_now = false
    current_temp_c = 20 

    assert Schedule.skip(past_24_rain_cm, past_24_avg_temp_c, raining_now, current_temp_c) == false
  end
end

defmodule ScheduleGeneratorTest do
  use ExUnit.Case
  alias Schedule.Generator
  alias GrassFarm.Schedule.SchedulePreferences

  test "generate_schedule creates a valid schedule" do
    # Sample forecast data
    forecast_data = [
      {"2023-07-01T00:00:00Z", 0, 25.0},
      {"2023-07-01T01:00:00Z", 0, 24.5},
      {"2023-07-01T02:00:00Z", 0, 24.0},
      {"2023-07-01T03:00:00Z", 0, 23.5},
      {"2023-07-01T04:00:00Z", 0, 23.0},
      {"2023-07-01T05:00:00Z", 0, 22.5},
      {"2023-07-01T06:00:00Z", 0, 22.0},
      {"2023-07-01T07:00:00Z", 0, 23.0},
      {"2023-07-01T08:00:00Z", 0, 24.5},
      {"2023-07-01T09:00:00Z", 0, 26.0},
      {"2023-07-01T10:00:00Z", 0, 27.5},
      {"2023-07-01T11:00:00Z", 0, 29.0},
      {"2023-07-01T12:00:00Z", 0, 30.5},
      {"2023-07-01T13:00:00Z", 0, 31.0},
      {"2023-07-01T14:00:00Z", 0, 31.5},
      {"2023-07-01T15:00:00Z", 0, 32.0},
      {"2023-07-01T16:00:00Z", 0, 31.5},
      {"2023-07-01T17:00:00Z", 0, 30.5},
      {"2023-07-01T18:00:00Z", 0, 29.0},
      {"2023-07-01T19:00:00Z", 0, 27.5},
      {"2023-07-01T20:00:00Z", 0, 26.0},
      {"2023-07-01T21:00:00Z", 0, 25.0},
      {"2023-07-01T22:00:00Z", 0, 24.5},
      {"2023-07-01T23:00:00Z", 0, 24.0},
      {"2023-07-02T00:00:00Z", 0, 23.5},
      {"2023-07-02T01:00:00Z", 0, 23.0},
    ]

    # Sample watering logs
    watering_logs = [
      %WaterLog{watering_datetime: "2023-06-30T07:00:00Z", watering_duration: 10},
      %WaterLog{watering_datetime: "2023-06-29T07:00:00Z", watering_duration: 15},
    ]

    # Sample schedule preferences
    schedule_preferences = %SchedulePreferences{}

    # Set a fixed start datetime for the test
    start_datetime = ~U[2023-07-01 00:00:00Z]

    # Generate the schedule
    schedule = Generator.generate_schedule(
      forecast_data,
      watering_logs,
      schedule_preferences,
      start_datetime
    )

    # Assert that the schedule is a list
    assert is_list(schedule)

    # Assert that each item in the schedule is a WaterLog struct
    Enum.each(schedule, fn item ->
      assert %WaterLog{} = item
      assert is_binary(item.watering_datetime)
      assert is_integer(item.watering_duration)
      assert item.watering_duration >= 8
    end)

    # Assert that the schedule covers 5 days
    schedule_dates = schedule
    |> Enum.map(fn %{watering_datetime: dt} ->
      {:ok, date} = Date.from_iso8601(String.slice(dt, 0, 10))
      date
    end)
    |> Enum.uniq()

    assert length(schedule_dates) <= 5

    # Assert that all scheduled waterings are in the future relative to the start_datetime
    Enum.each(schedule, fn %{watering_datetime: dt} ->
      {:ok, scheduled_datetime, _} = DateTime.from_iso8601(dt)
      assert DateTime.compare(scheduled_datetime, start_datetime) == :gt
    end)
  end
end

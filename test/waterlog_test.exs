defmodule WaterLogTest do
  use ExUnit.Case

  setup_all _context do
    now = DateTime.now!("Etc/UTC")

    now_string = DateTime.to_string(now)

    past_watering_event =
      WaterLog.create_log_event(
        DateTime.add(now, -79200), #22 hours in the past
        12
      )

    past_watering_event_2 =
      WaterLog.create_log_event(
        DateTime.add(now, -43200), #12 hours in the past
        8
      )

    future_watering_event =
      WaterLog.create_log_event(
        DateTime.add(now, 36000), #12 hours in the future
        8
      )

    future_watering_event_2 =
      WaterLog.create_log_event(
        DateTime.add(now, 64800), #18 hours in the future
        12
      )

    [
      past_watering_event: past_watering_event,
      past_watering_event_2: past_watering_event_2,
      now: now,
      now_string: now_string,
      future_watering_event: future_watering_event,
      future_watering_event_2: future_watering_event_2,
      log: [past_watering_event, past_watering_event_2]
    ]
  end

  test "create new watering event", context do
    assert WaterLog.create_log_event(context.now, 10) ==
      %WaterLog{
        watering_datetime: context.now_string,
        watering_duration: 10
      }
  end

  test "rotate_water_log removes expired log and adds new log", context do

    activity = WaterLog.create_log_event(context.now, 10)

    assert WaterLog.rotate_water_log(context.log, context.now, activity) ==
      [
        context.past_watering_event,
        context.past_watering_event_2,
        activity
      ]
  end

  test "update watering forecast creates a future schedule", context do
    assert WaterLog.update_watering_forecast(context.log, context.past_watering_event, context.now) ==
      []

    new_log = [ context.future_watering_event ]

    assert WaterLog.update_watering_forecast(context.log, context.future_watering_event, context.now) ==
      new_log

    assert WaterLog.update_watering_forecast(new_log, context.future_watering_event_2, context.now) ==
      [ context.future_watering_event, context.future_watering_event_2 ]
  end

end

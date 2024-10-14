defmodule Schedule.Generator do
  alias FuzzyInput.Inputs
  alias FuzzyInput.Calculator

  @spec generate_schedule(
          forecast_data :: list({String.t(), float(), float()}),
          watering_logs :: list(WaterLog.t()),
          schedule_preferences :: SchedulePreferences.t(),
          start_datetime :: DateTime.t()
        ) :: list(WaterLog.t())
  def generate_schedule(
        forecast_data,
        watering_logs,
        schedule_preferences,
        start_datetime \\ DateTime.utc_now()
      ) do
    Enum.reduce(0..4, {[], watering_logs}, fn day_offset, {schedule, logs} ->
      current_date = Date.add(DateTime.to_date(start_datetime), day_offset)
      day_of_week = Date.day_of_week(current_date) |> day_of_week_atom()

      times = Map.get(schedule_preferences, day_of_week)

      # Collect scheduled waterings for the day (primary and secondary)
      {day_schedule, updated_logs} =
        Enum.reduce([:primary, :secondary], {[], logs}, fn time_key, {acc, logs_acc} ->
          scheduled_time = Map.get(times, time_key)

          if scheduled_time do
            scheduled_datetime =
              DateTime.new!(current_date, scheduled_time, start_datetime.time_zone)

            # Compute Fuzzy.Inputs using data prior to the scheduled time
            fuzzy_inputs =
              Calculator.calculate_fuzzy_inputs(
                forecast_data,
                logs_acc,
                scheduled_datetime
              )

            # Simulate watering decision
            watering_duration = simulate_watering_decision(fuzzy_inputs)

            # Schedule watering if duration >= 8 minutes
            if watering_duration >= 8 do
              watering_event = %WaterLog{
                watering_datetime: DateTime.to_iso8601(scheduled_datetime),
                watering_duration: watering_duration
              }

              # Update logs and schedule
              {
                [watering_event | acc],
                [watering_event | logs_acc]
              }
            else
              {acc, logs_acc}
            end
          else
            {acc, logs_acc}
          end
        end)

      {day_schedule ++ schedule, updated_logs}
    end)
    |> elem(0)
    |> Enum.reverse()
  end

  # Helper function to convert day number to atom
  defp day_of_week_atom(day_number) do
    case day_number do
      1 -> :monday
      2 -> :tuesday
      3 -> :wednesday
      4 -> :thursday
      5 -> :friday
      6 -> :saturday
      7 -> :sunday
    end
  end

  # Simulate watering decision function
  defp simulate_watering_decision(%Inputs{} = _inputs) do
    :rand.seed(:exsplus, :os.timestamp())
    duration = :rand.uniform(20) - 1  # Generates 0 to 19 minutes
    duration
  end
end


defmodule FuzzyInput.Calculator do
  alias FuzzyInput.Inputs

  @spec calculate_fuzzy_inputs(
          forecast_data :: list({String.t(), float(), float()}),
          watering_logs :: list(WaterLog.t()),
          current_datetime :: DateTime.t()
        ) :: Inputs.t()
  def calculate_fuzzy_inputs(forecast_data, watering_logs, current_datetime \\ DateTime.utc_now()) do
    rain_24h_prior = calculate_rain_24h_prior(forecast_data, current_datetime)
    temp_24h_prior = calculate_temp_24h_prior(forecast_data, current_datetime)
    watering_36h_prior = calculate_watering_36h_prior(watering_logs, current_datetime)
    wetness_score = calculate_wetness_score(rain_24h_prior, temp_24h_prior, watering_36h_prior)

    %Inputs{
      rain_24h_prior: rain_24h_prior,
      temp_24h_prior: temp_24h_prior,
      wetness_score: wetness_score,
      watering_36h_prior: watering_36h_prior
    }
  end

  # Calculates total rainfall in the past 24 hours
  defp calculate_rain_24h_prior(forecast_data, current_datetime) do
    forecast_data
    |> Enum.filter(fn {timestamp, _, _} ->
      within_past_hours?(timestamp, current_datetime, 24)
    end)
    |> Enum.map(fn {_, rain, _} -> rain end)
    |> Enum.sum()
  end

  # Calculates average temperature over the past 24 hours
  defp calculate_temp_24h_prior(forecast_data, current_datetime) do
    temps =
      forecast_data
      |> Enum.filter(fn {timestamp, _, _} ->
        within_past_hours?(timestamp, current_datetime, 24)
      end)
      |> Enum.map(fn {_, _, temp} -> temp end)

    case temps do
      [] -> 0.0
      _ -> Enum.sum(temps) / length(temps)
    end
  end

  # Calculates total watering duration in the past 36 hours
  defp calculate_watering_36h_prior(watering_logs, current_datetime) do
    watering_logs
    |> Enum.filter(fn %WaterLog{watering_datetime: datetime_str} ->
      within_past_hours?(datetime_str, current_datetime, 36)
    end)
    |> Enum.map(& &1.watering_duration)
    |> Enum.sum()
  end

  # Helper function to check if a timestamp is within the past N hours
  defp within_past_hours?(datetime_str, current_datetime, hours) do
    {:ok, datetime, _} = DateTime.from_iso8601(datetime_str)
    diff_seconds = DateTime.diff(current_datetime, datetime, :second)
    diff_seconds >= 0 and diff_seconds <= hours * 3600
  end

  # Placeholder for wetness score calculation
  defp calculate_wetness_score(rain_24h_prior, temp_24h_prior, watering_36h_prior) do
    # Replace this with your actual calculation logic
    # Example formula:
    score = (rain_24h_prior * 0.5) - (temp_24h_prior * 0.2) + (watering_36h_prior * 0.3)
    score |> max(-100) |> min(100)
  end
end


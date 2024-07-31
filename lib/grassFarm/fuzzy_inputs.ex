defmodule Fuzzy.Inputs do

  @type t:: %__MODULE__{
    rain_24h_prior: float(),
    temp_24h_prior: float(),
    operator_score: float(),
    watering_36h_prior: float()
  }
  
  defstruct [
    rain_24h_prior: 0,
    temp_24h_prior: 0,
    operator_score: 0,
    watering_36h_prior: 0,
  ]

  def prewatering_history(history_full, forecast_full, watering_time) do
    {latest_history, _rain, _temp} = List.last(history_full)
    {:ok, latest_history_time, 0} = DateTime.from_iso8601(latest_history)

    grab = 
      DateTime.diff(watering_time, latest_history_time)/(60 * 60)
      |> Kernel.round()
        
    grab_hist = 24 - grab
    history = Enum.slice(history_full, (-grab_hist - 1)..-2)
    forecast = Enum.slice(forecast_full, 0..(grab - 1))

    history ++ forecast
  end

  def decay_operator_score({score, set_date, now}) do
                                                    # y = mx + b straight line decay; b = 0
    slope_sign = if score > 0, do: -1, else: 1      # if score is above 0, the m will be negative
    m = (slope_sign * 100) / ( 24 * 60 * 60 )       # the number of seconds in a 24 hour period
    x = NaiveDateTime.diff(now, set_date, :second)  # how many milliseconds have passed since set date
    m * x + score
  end
end

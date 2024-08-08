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

  alias Fuzzy.Inputs

  def prewatering_history(history_full, forecast_full, watering_time) do
    {latest_history, _rain, _temp} = List.last(history_full)
    {:ok, latest_history_time, 0} = DateTime.from_iso8601(latest_history)

    grab = 
      DateTime.diff(watering_time, latest_history_time)/(60 * 60)
      |> Kernel.round()
        
    grab_hist = 24 - grab
    history = Enum.slice(history_full, -grab_hist..-1)
    forecast = Enum.slice(forecast_full, 1..grab)

    history ++ forecast
  end

  def seat_weather_data(pre_watering) do
    rain = pre_watering
      |> Enum.reduce( 0, fn x, acc -> acc + elem(x,1) end)
    
    avg_24 = fn(a) -> a/24 end
    
    temp = pre_watering
      |> Enum.reduce( 0, fn x, acc -> acc + elem(x,2) end)
      |> avg_24.()
      |> round()
    
    %Inputs{
      rain_24h_prior: rain,
      temp_24h_prior: temp,
      operator_score: 0,
      watering_36h_prior: 0
    }
  end

  def decay_operator_score({score, set_date, now}) do
    # y = mx + b straight line decay; b = 0
    # slope_sign --> if score is above 0, the m will be negative
    # m the number of seconds in a 24 hour period# 
    # x = how many milliseconds have passed since set date

    slope_sign = if score > 0, do: -1, else: 1
    m = (slope_sign * 100) / ( 24 * 60 * 60 )       
    x = NaiveDateTime.diff(now, set_date, :second)  
    m * x + score
  end
end

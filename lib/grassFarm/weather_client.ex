defmodule WeatherClientTomorrow do
  use Tesla

  # Specify the base URL of the weather API
  @base_url "https://api.tomorrow.io/v4/weather"
  @local_tz "America/Chicago"

  # Define your Tesla middleware stack
  plug(Tesla.Middleware.BaseUrl, @base_url)
  plug(Tesla.Middleware.JSON)

  plug(Tesla.Middleware.Query,
    apikey: System.get_env("TOMORROW_APIKEY"),
    location: System.get_env("LATLON"),  
    timesteps: "1h",
    units: "metric"
  )

  plug(Tesla.Middleware.Headers, [{"User-Agent", "Tesla"}, {"accept", "application/json"}])

  def get_weather_history() do
    case get("/history/recent") do
      {:ok, %Tesla.Env{status: 200, body: body}} ->
        parse_weather(body)

      {:ok, %Tesla.Env{status: status}} ->
        {:error, "Request failed with status: #{status}"}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def get_weather_forecast() do
    case get("/forecast") do
      {:ok, %Tesla.Env{status: 200, body: body}} ->
        parse_weather(body)

      {:ok, %Tesla.Env{status: status}} ->
        {:error, "Request failed with status: #{status}"}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp parse_weather(body) do
    body["timelines"]["hourly"]
    |> Enum.map(fn x ->
      {
        x["time"],
        x["values"]["rainAccumulation"],
        x["values"]["temperature"]
      }
    end)
  end
  
  def get_formatted_history(watering_datetime) do
    utc_watering_dt = 
      DateTime.from_naive!(watering_datetime, @local_tz)
      |> DateTime.shift_zone!("Etc/UTC")

    get_weather_history()
      |> Enum.filter(fn {dt, _rain, _temp} -> 
           {:ok, new_utc, 0} = DateTime.from_iso8601(dt)
           DateTime.diff(utc_watering_dt, new_utc, :second) < ( 60 * 60 * 24 )
         end )    
  end
end

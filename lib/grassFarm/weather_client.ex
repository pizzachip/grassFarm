defmodule WeatherClientTomorrow do
  use Tesla

  # Specify the base URL of the weather API
  @base_url "https://api.tomorrow.io/v4/weather"

  # Define your Tesla middleware stack
  plug(Tesla.Middleware.BaseUrl, @base_url)
  plug(Tesla.Middleware.JSON)

  plug(Tesla.Middleware.Query,
    apikey: "",
    location: "33.090320,-96.914140",
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
end

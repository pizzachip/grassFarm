defmodule WeatherClient do
  use Tesla

  # Specify the base URL of the weather API - NOTE this is only call I can make with free plan
  @base_url "http://api.openweathermap.org/data/2.5/forecast"
  @lat "33.06480"
  @lon "96.88968"
  @appid "09c2e314057e0ae4a34ff5a53711934e" # For testing ONLY TODO remove after it works!!!

  # Define your Tesla middleware stack
  plug Tesla.Middleware.BaseUrl, @base_url
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Query, [appid: @appid, units: "metric"]
  plug Tesla.Middleware.Headers, [{"User-Agent", "Tesla"}]

  # Function to fetch rainfall data for the past 24 hours
  def get_rainfall(lat \\ @lat, lon \\ @lon) do
    case get("/", query: [lat: lat, lon: lon]) do
      {:ok, %Tesla.Env{status: 200, body: body}} ->
        body

      {:ok, %Tesla.Env{status: status}} ->
        {:error, "Request failed with status: #{status}"}

      {:error, reason} ->
        {:error, reason}
    end
  end

  # Helper function to parse the rainfall data from the API response
  defp parse_rainfall(%{"hourly" => hourly_data}) do
    hourly_data
    |> Enum.map(&(&1["rain"]["1h"] || 0))
    |> Enum.sum()
    |> (&{:ok, &1}).()
  end
end


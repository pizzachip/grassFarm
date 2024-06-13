defmodule WeatherClient do
  use Tesla

  # Specify the base URL of the weather API
  @base_url "http://api.openweathermap.org/data/2.5/onecall"

  # Define your Tesla middleware stack
  plug Tesla.Middleware.BaseUrl, @base_url
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Query, [appid: "your_api_key", units: "metric"]
  plug Tesla.Middleware.Headers, [{"User-Agent", "Tesla"}]

  # Function to fetch rainfall data for the past 24 hours
  def get_rainfall(lat, lon) do
    case get("/timemachine", query: [lat: lat, lon: lon, dt: :os.system_time(:second) - 86400]) do
      {:ok, %Tesla.Env{status: 200, body: body}} ->
        parse_rainfall(body)

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


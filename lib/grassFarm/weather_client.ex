defmodule WeatherClient do
  use Tesla

  # Specify the base URL of the weather API
  @base_url "http://api.openweathermap.org/data/3.0/onecall"
  @lat "33.096470"
  @lon "-96.887009"

  # Define your Tesla middleware stack
  plug Tesla.Middleware.BaseUrl, @base_url
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Query, [appid: "09c2e314057e0ae4a34ff5a53711934e
", units: "metric"]
  plug Tesla.Middleware.Headers, [{"User-Agent", "Tesla"}]

  # Function to fetch rainfall data for the past 24 hours
  def get_rainfall(lat \\ @lat , lon \\ @lon) do
    # case get("/timemachine", query: [lat: lat, lon: lon, dt: :os.system_time(:second) - 86400]) do
    #   {:ok, %Tesla.Env{status: 200, body: body}} ->
    #     parse_rainfall(body)

    case get("/", query: [lat: lat, lon: lon]) do
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


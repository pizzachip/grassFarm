defmodule WeatherClient do
  use Tesla

  # Specify the base URL of the weather API - NOTE this is only call I can make with free plan
  @base_url "https://www.ncei.noaa.gov/cdo-web/api/v2/"
  @datasetid "PRECIP_HLY"
  @locationid "ZIP:75056"
  @startdate "2024-06-14" 
  @enddate "2024-06-15"
  @token "jmClsFqQLIhfFIBVZzQxPfMgKiPjEeeM" # For testing ONLY TODO remove after it works!!!

  # Define your Tesla middleware stack
  plug Tesla.Middleware.BaseUrl, @base_url
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Query, [units: "metric"]
  plug Tesla.Middleware.Headers, [
    {"User-Agent", "Tesla"},
    {"token", @token}
  ]

  # Function to fetch rainfall data for the past 24 hours
  def get_weather(
    locationid \\ @locationid,
    datasetid \\ @datasetid,
    locationid \\ @locationid,
    startdate \\ @startdate,
    enddate \\ @enddate
  ) do
    case get("/data", query: [
      datasetid: datasetid,
      locationid: locationid,
      startdate: startdate,
      enddate: enddate
    ]) do
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


defmodule Durations.DurationAdapter do
  alias Durations.Duration

  def new(params, module \\ from_env()) do
    adapter = module.__struct__(params)

    module.new(adapter)
  end

  def retrieve_heat(adapter), do: Duration.retrieve_heat(adapter)
  def retrieve_rain(adapter), do: Duration.retrieve_rain(adapter)
  def retrieve_human_ass(adapter), do: Duration.retrieve_human_ass(adapter)
  def retrieve_last_water(adapter), do: Duration.retrieve_last_water(adapter)

  defp from_env, do: Application.get_env(:grassFarm, :duration_adapter)
end

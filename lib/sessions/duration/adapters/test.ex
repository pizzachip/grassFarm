defmodule Sessions.DurationAdapter.Test do
  defstruct [:params]

  alias Durations.Duration

  def new(adapter) do
    adapter
  end

  defimpl Duration, for: Test do
    def retrieve_heat(_adapter) do
       [21, 22, 23, 23, 23, 24, 24, 25, 24, 24, 24, 23]
    end
    def retrieve_rain(adapter), do: adapter
    def retrieve_human_ass(adapter), do: adapter
    def retrieve_last_water(adapter), do: adapter
  end

end

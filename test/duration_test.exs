defmodule DurationTest do
  use ExUnit.Case
  doctest Durations.Duration

  alias Durations.Duration
  alias Durations.DurationAdapter

  setup_all do
    :ok
  end

  setup do
    adapter = DurationAdapter.new(
      %{
         now: ~N[2024-06-25 19:30:00.001], #current time
         watering_time: ~N[2024-06-26 07:00:00.001]  #start time 
      }
    )

    [adapter: adapter]
    
  end

  test "retrieve heat from api test", context do

    assert DurationAdapter.retrieve_heat(context.adapter).value ==   
       [21, 22, 23, 23, 23, 24, 24, 25, 24, 24, 24, 23]
  end

  test "retrieve rain from api test", context do
    response = DurationAdapter.retrieve_rain(context.adapter)
    assert Enum.sum(response.value) == 1   
    assert response.measurement_type == :rain 
  end
end

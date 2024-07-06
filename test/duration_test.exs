defmodule DurationTest do
  use ExUnit.Case
  doctest Durations.Duration

  alias Durations.Duration
  alias Durations.DurationAdapter

  # I may need to change the params to reflect zulu time rather than local time depending on the API adapter

  setup context do
    [
      params: {
        ~N[2024-06-25 19:30:00.001], #current time
        ~N[2024-06-26 07:00:00.001]  #start time 
      }
    ]
  end
  
  test "retrieve heat from api test", context do
    IO.inspect(context.params)
    adapter = DurationAdapter.new(context.params)

    assert DurationAdapter.retrieve_heat(adapter) ==   
       [21, 22, 23, 23, 23, 24, 24, 25, 24, 24, 24, 23]
  end
end

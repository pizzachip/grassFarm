defmodule Durations.DurationAdapter.Test do
   
  defstruct [ :measurement_type, :now, :watering_time, :value ]

  alias Durations.Duration
  alias Durations.DurationAdapter.Test

  def new(params) do
    %Test{
      measurement_type: nil,
      now: params.now,
      watering_time: params.watering_time,
      value: nil
    } 
  end

  defimpl Duration, for: Test do
    def retrieve_heat(adapter) do
      %{adapter | 
        value: [21, 22, 23, 23, 23, 24, 24, 25, 24, 24, 24, 23],
        measurement_type: :heat
      }
    end
    
    def retrieve_rain(adapter) do
      %{adapter | 
        value: [0.25, 0.15, 0, 0, 0, 0, 0, 0, 0.1, 0.5, 0], # 1cm total rain
        measurement_type: :rain
      }
    end

    def retrieve_operator_score(adapter) do
      %{adapter | operator_score: 74 }
    end

    def retrieve_last_water(adapter) do
      adapter
    end
  end

end

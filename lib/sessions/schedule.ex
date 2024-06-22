defmodule Sessions.Schedule  do

  @type t:: %__MODULE__{
    start: NaiveDateTime.t(),
    sessions: [Sessions.Session.t()]
  }
  defstruct [:start, sessions: []]

  def set_cumm_rain_start(now, schedule_start) do
    past_event = DateTime.after?(now, schedule_start)

    if past_event do
      {:error, "cannot skip past event"}
    else
      DateTime.add(schedule_start, -24, :hour)
    end
  end

  def skip(
    past_24_rain_cm,
    past_24_avg_temp_c,
    raining_now,
    current_temp_c) do
    
    # This will be replaced with a fuzzy logic model

    cond do
      past_24_rain_cm > 2 -> true
      # past_24_avg_temp_c -> true
      raining_now -> true
      current_temp_c < 5 -> true
      true -> false
    end
  end
end

defmodule WaterLog do

  @type t:: %__MODULE__{
    watering_datetime: String.t(),
    watering_duration: integer()
  }

  defstruct [
    watering_datetime: nil,
    watering_duration: 0,
  ]

  alias Persist.PersistAdapter


  @spec create_log_event(DateTime.t(), integer()) :: WaterLog.t()
  def create_log_event(time, duration) do
    %__MODULE__{
      watering_datetime: DateTime.to_string(time),
      watering_duration: duration
    }
  end

  @spec record_watering(Waterlog.t()) :: [WaterLog]
  def record_watering(watering_activity) do
    log =
      PersistAdapter.new(%{set_name: "water_log", configs: watering_activity})
      |> PersistAdapter.local_read

    now =
      DateTime.now!("Etc/UTC")

    rotate_water_log(log, now, watering_activity)
  end

  @spec update_watering_forecast([WaterLog.t()], WaterLog.t(), DateTime.t()) :: [WaterLog.t()]
  def update_watering_forecast(log, event, now) do
    with {:ok, event_datetime, _} <- DateTime.from_iso8601(event.watering_datetime),
         :gt <- DateTime.compare(event_datetime, now) do
      (log ++ [event])
      |> filter_future_events(now)
      |> Enum.sort_by(&(&1.watering_datetime))
    else
      _ -> []
    end
  end

  defp filter_future_events(events, now) do
    Enum.filter(events, fn event ->
      case DateTime.from_iso8601(event.watering_datetime) do
        {:ok, event_datetime, _} -> DateTime.compare(event_datetime, now) == :gt
        _ -> false
      end
    end)
  end

  def rotate_water_log(log, now, watering_activity) do
    log
    |> remove_expired_waterings(now)
    |> add_watering_activity(watering_activity)
  end

  @spec remove_expired_waterings([WaterLog.t()], DateTime.t()) :: [WaterLog.t()]
  def remove_expired_waterings(log, now) do
      Enum.filter(log, fn x ->
        {:ok, datetime, 0} = DateTime.from_iso8601(x.watering_datetime)
        DateTime.diff(now, datetime) < 129600 end
      )
  end

  @spec add_watering_activity([WaterLog.t()], WaterLog.t()) :: [WaterLog.t()]
  def add_watering_activity(log, watering_activity) do
    log ++ [watering_activity]
  end

end

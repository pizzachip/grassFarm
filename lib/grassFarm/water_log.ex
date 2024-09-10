defmodule GrassFarm.WaterLog do

  @type t:: %__MODULE__{
    watering_datetime: String.t(),
    watering_duration: integer()
  }

  defstruct [
    watering_datetime: nil,
    watering_duration: 0,
  ]

  alias GrassFarm.WaterLog
  alias GrassFarm.PersistAdapter


  @spec create_log_event(DateTime.t(), integer()) :: WaterLog.t() 
  def create_log_event(time, duration) do
    %WaterLog{
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

  def update_watering_forecast(log, event, now) do
    [] 
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

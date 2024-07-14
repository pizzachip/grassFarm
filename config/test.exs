import Config

# Add configuration that is only needed when running on the host here.

config :grassFarm, 
  zone_control_adapter: GrassFarm.Zones.ZoneControlAdapter.Test,
  calendar_adapter: Sessions.CalendarAdapter.Test,
  duration_adapter: Durations.DurationAdapter.Test

defmodule Sessions.CalendarAdapter do
  alias Sessions.Calendar

  def new(params, module \\ from_env()) do
    adapter = module.__struct__(params)

    module.new(adapter)
  end

  def get_calendar(adapter), do: Calendar.get_calendar(adapter)
  def update_calendar(adapter), do: Calendar.update_calendar(adapter)
  def save_calendar(adapter), do: Calendar.save_calendar(adapter)

  defp from_env, do: Application.get_env(:grassFarm, :calendar_adapter)
end

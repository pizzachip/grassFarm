defmodule Sessions.CalendarAdapter do
  alias Sessions.Calendar

  def new(params, module \\ from(env)) do
    adapter = module.__struct__(params)

    module.new(adapter)
  end

  def get_calendar(adapter), do: Sessions.get_calendar(adapter)
  def update_calendar(adapter), do: Sessions.update_calendar(adapter)
  def save_calendar(adapter), do: Sessions.save_calendar(adapter)

  defp from_env, do: Application.get_env(:grass_farm, :calendar_adapter)
end

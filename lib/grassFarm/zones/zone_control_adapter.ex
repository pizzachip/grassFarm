defmodule GrassFarm.Zones.ZoneConrolAdapter do
  alias GrassFarm.Zones.ZoneControl

  def new(params, module \\ from_env()) do
    adapter = module.__struct__(id: params.id, configs: params.configs)

    module.new(adapter)
  end

  def start(adapter), do: ZoneControl.start(adapter)
  def stop(adapter), do: ZoneControl.stop(adapter)
  def check_status(adapter), do: ZoneControl.check_status(adapter)

  defp from_env, do: Application.get_env(:grassFarm, :zone_control_adapter)
end

defmodule GrassFarm.Zones.ZoneControlAdapter.Test do

  alias GrassFarm.Zone
  alias GrassFarm.ZoneControl
  alias GrassFarm.Zones.ZoneControlAdapter.Test

  def new(adapter) do
    adapter
  end

  defimpl ZoneControl, for: Test do
    def start(adapter) do
      adapter
    end 

    def stop(adapter) do
      adapter
    end

    def check_status(adapter) do
      adapter
    end
  end
end

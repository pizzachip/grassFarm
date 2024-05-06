defmodule GrassFarm.Zone do

  @enforce_keys [:id]
  defstruct [:id, :gpio_port, name: "New Zone", status: :off]

end

defmodule Valves.Valve do

  @type t:: %__MODULE__{
    id: integer(),
    gpio_pin: integer(),
    name: String.t()
  }
  defstruct [:id, :gpio_pin, name: "New Valve"]
 
end

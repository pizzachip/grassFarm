defmodule Sessions.Session do

  @type t:: %__MODULE__{
    valve_id: integer(),
    minutes: integer()
  }
  defstruct [:valve_id, minutes: 12]

end
